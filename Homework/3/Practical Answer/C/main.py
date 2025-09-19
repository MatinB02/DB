from fastapi import FastAPI, Depends, HTTPException
from sqlalchemy.orm import Session
from db.session import SessionLocal
from db.models import User, Anime, UserAnime

app = FastAPI()

# Dependency to get DB session
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

# Route 1: Get all anime
@app.get("/anime/")
def get_all_anime(db: Session = Depends(get_db)):
    return db.query(Anime).limit(20).all()  # limit to 20 results


# Route 3: Get user's anime list
@app.get("/users/{username}/anime")
def get_user_anime(username: str, db: Session = Depends(get_db)):
    user_anime = db.query(UserAnime).filter(UserAnime.username == username).all()
    return user_anime






# _________________________________________________________Query 1:
from sqlalchemy import cast, Integer
from fastapi.responses import JSONResponse

@app.get("/anime/top")
def get_top_anime_by_episodes(db: Session = Depends(get_db)):
    anime_list = (
        db.query(Anime)
        .filter(Anime.episodes != None)
        .filter(cast(Anime.episodes, Integer) != None)
        .order_by(cast(Anime.episodes, Integer).desc())
        .limit(10)
        .all()
    )

    result = [
        {
            "anime_id": anime.anime_id,
            "title_english": anime.title_english,
            "score": anime.score,
            "episodes": anime.episodes
        }
        for anime in anime_list
    ]
    return JSONResponse(content=result)

# _________________________________________________________General Users:
# @app.get("/users/")
# def get_users(db: Session = Depends(get_db)):
#     users = db.query(User.username).limit(10).all()
#     return [u[0] for u in users]

# _________________________________________________________Query 2:

from fastapi import Query
from sqlalchemy import desc, Float, Date
from db.session import SessionLocal

@app.get("/users/top")
def get_top_users(
    page: int = Query(1, ge=1),
    offset: int = Query(10, ge=1),
    year: int = Query(2017),
    gender: str = Query("Female"),
    db: Session = Depends(get_db)
):
    skip = (page - 1) * offset

    users = (
        db.query(User.username, User.stats_mean_score)
        .filter(
            User.gender == gender,
            User.stats_mean_score != None,
            cast(User.stats_mean_score, Float) > 8,
            User.join_date != None,
            cast(User.join_date, Date) > f"{year}-01-01"
        )
        .order_by(desc(cast(User.stats_mean_score, Float)))
        .offset(skip)
        .limit(offset)
        .all()
    )

    return [
        {
            "username": user.username,
            "stats_mean_score": user.stats_mean_score,
        }
        for user in users
    ]



# _________________________________________________________Query 3:
@app.get("/users/{username}/watched")
def get_user_watched_anime(
    username: str, 
    count: int = Query(10, ge=1, le=100),  # Default to 10, with min 1 and max 100
    db: Session = Depends(get_db)
):
    # First check if user exists
    user = db.query(User).filter(User.username == username).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")

    # Query for watched anime
    watched_anime = (
        db.query(
            UserAnime.my_score,
            Anime.anime_id,
            Anime.title_english,
            Anime.episodes
        )
        .join(Anime, UserAnime.anime_id == Anime.anime_id)
        .filter(
            UserAnime.username == username,
            UserAnime.my_watched_episodes != "0",
            UserAnime.my_score != None
        )
        .order_by(UserAnime.my_score.asc())  # Ascending order by user's score
        .limit(count)
        .all()
    )

    # Format the response
    result = [
        {
            "anime_id": anime.anime_id,
            "title_english": anime.title_english,
            "user_score": anime.my_score,
            "episodes": anime.episodes
        }
        for anime in watched_anime
    ]

    return JSONResponse(content=result)

# _________________________________________________________Query 4:

from sqlalchemy import func
from collections import Counter
from fastapi import HTTPException
from fastapi.responses import JSONResponse

@app.get("/anime/popular")
def get_popular_genres(db: Session = Depends(get_db)):
    # Get all watched anime (where at least one episode was watched)
    watched_anime = (
        db.query(UserAnime.my_tags)
        .filter(
            UserAnime.my_watched_episodes != "0",
            UserAnime.my_tags != None
        )
        .all()
    )

    if not watched_anime:
        raise HTTPException(status_code=404, detail="No watched anime found")

    # Process tags to count individual genres with case normalization
    genre_counter = Counter()
    
    for anime in watched_anime:
        if anime.my_tags:
            # Clean, normalize case, and split tags
            tags = [tag.strip().capitalize() for tag in anime.my_tags.split(",") if tag.strip()]
            genre_counter.update(tags)

    # Get top 3 genres
    top_genres = [genre for genre, count in genre_counter.most_common(3)]

    return JSONResponse(content={
        "popular_genres": top_genres,
        "genre_counts": dict(genre_counter.most_common(3))
    })




# _________________________________________________________Query 5:
from datetime import datetime
from sqlalchemy import func, case, and_, or_, cast, Date, Integer
from fastapi import HTTPException

@app.get("/users/active/{year}")
def get_most_active_users(year: int, db: Session = Depends(get_db)):
    # Validate year input
    current_year = datetime.now().year
    if year < 1900 or year > current_year:
        raise HTTPException(
            status_code=400,
            detail=f"Year must be between 1900 and {current_year}"
        )

    # difference calculation
    watch_days_case = case(
        (
            and_(
                UserAnime.my_start_date.isnot(None),
                UserAnime.my_finish_date.isnot(None),
                UserAnime.my_start_date.like(f"{year}-%"),
                UserAnime.my_finish_date.like(f"{year}-%")
            ),
            (cast(UserAnime.my_finish_date, Date) - cast(UserAnime.my_start_date, Date) + 1)
        ),
        else_=1
    ).label("watch_days")

    active_users = (
        db.query(
            UserAnime.username,
            func.sum(watch_days_case).cast(Integer).label("watch_days")
        )
        .filter(
            or_(
                UserAnime.my_start_date.like(f"{year}-%"),
                UserAnime.my_finish_date.like(f"{year}-%")
            ),
            UserAnime.my_watched_episodes != "0"
        )
        .group_by(UserAnime.username)
        .order_by(func.sum(watch_days_case).desc())
        .limit(5)
        .all()
    )

    if not active_users:
        raise HTTPException(
            status_code=404,
            detail=f"No active users found in {year}"
        )

    # Format the response
    result = [
        {
            "username": user.username,
            "watch_days": user.watch_days
        }
        for user in active_users
    ]

    return {"active_users": result}


# _________________________________________________________Query 6:

@app.get("/users/{username}/similars")
def get_similar_users(username: str, db: Session = Depends(get_db)):
    # check if the user exists
    user_exists = db.query(User).filter(User.username == username).first()
    if not user_exists:
        raise HTTPException(status_code=404, detail="User not found")

    # anime IDs watched by the user
    target_user_anime = (
        db.query(UserAnime.anime_id)
        .filter(
            UserAnime.username == username,
            UserAnime.my_watched_episodes != "0"
        )
        .subquery()
    )

    # find similar users
    similar_users = (
        db.query(
            UserAnime.username,
            func.count(UserAnime.anime_id).label("shared_anime_count")
        )
        .filter(
            UserAnime.username != username,  # Exclude the target user
            UserAnime.anime_id.in_(target_user_anime),
            UserAnime.my_watched_episodes != "0"
        )
        .group_by(UserAnime.username)
        .order_by(func.count(UserAnime.anime_id).desc())
        .all()
    )

    if not similar_users:
        raise HTTPException(
            status_code=404,
            detail=f"No similar users found for {username}"
        )

  
    result = [
        {
            "username": user.username,
            "shared_anime_count": user.shared_anime_count
        }
        for user in similar_users
    ]

    return JSONResponse(content={"similar_users": result})


# _________________________________________________________Query 7:
from fastapi import Query

@app.post("/anime/{anime_id}/episodes")
def increment_episode_count(
    anime_id: str,
    value: int = Query(1, ge=1),  # Default 1, minimum 1
    db: Session = Depends(get_db)
):

    anime = db.query(Anime).filter(Anime.anime_id == anime_id).first()
    if not anime:
        raise HTTPException(status_code=404, detail="Anime not found")

    try:
        # Get current episode count (handle null/empty cases)
        current_episodes = anime.episodes or "0"
        current_count = int(current_episodes)
        
        new_count = current_count + value
        
        anime.episodes = str(new_count)
        db.commit()
        
        return {
            "anime_id": anime_id,
            "current_episodes": str(new_count)
        }
        
    except ValueError:
        raise HTTPException(
            status_code=400,
            detail="Current episode count is not a valid number"
        )






# Route 2: Get user profile by username
@app.get("/users/{username}")
def get_user(username: str, db: Session = Depends(get_db)):
    user = db.query(User).filter(User.username == username).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    return user
