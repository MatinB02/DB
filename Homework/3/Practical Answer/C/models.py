from sqlalchemy import Column, String, Text, ForeignKey
from sqlalchemy.orm import relationship, declarative_base

Base = declarative_base()

class Anime(Base):
    __tablename__ = "anime_list"

    anime_id = Column(String, primary_key=True)
    title_english = Column(Text)
    title_synonyms = Column(Text)
    genre = Column(Text)
    episodes = Column(Text)
    score = Column(Text)
    image_url = Column(Text)

    # more fields

    user_entries = relationship("UserAnime", back_populates="anime")


class User(Base):
    __tablename__ = "user_list"

    username = Column(String, primary_key=True, index=True)
    location = Column(Text)
    gender = Column(Text)
    join_date = Column(Text)
    birth_date = Column(Text)
    user_id = Column(String)
    stats_mean_score = Column(String)

    # more fields

    anime_entries = relationship("UserAnime", back_populates="user")


class UserAnime(Base):
    __tablename__ = "user_anime_list"

    anime_id = Column(String, ForeignKey("anime_list.anime_id"), primary_key=True)
    username = Column(String, ForeignKey("user_list.username"), primary_key=True)
    my_score = Column(Text)
    my_status = Column(Text)
    my_tags = Column(Text)
    my_start_date = Column(Text)
    my_finish_date = Column(Text)
    my_watched_episodes = Column(Text)

    anime = relationship("Anime", back_populates="user_entries")
    user = relationship("User", back_populates="anime_entries")

