WITH playlist_details AS (
    SELECT 
        pl.PlaylistId,
        pl.Name AS PlaylistName,
        g.Name AS GenreName,
        ar.Name AS ArtistName,
        CONCAT(g.Name, ' by ', ar.Name) AS GenreArtist
    FROM Playlist pl
    JOIN PlaylistTrack plt ON pl.PlaylistId = plt.PlaylistId
    JOIN Track t ON plt.TrackId = t.TrackId
    JOIN Genre g ON t.GenreId = g.GenreId
    JOIN Album al ON t.AlbumId = al.AlbumId
    JOIN Artist ar ON al.ArtistId = ar.ArtistId
),
playlist_grouped AS (
    SELECT 
        PlaylistId,
        PlaylistName,
        COUNT(DISTINCT GenreName) AS genre_count,
        COUNT(DISTINCT ArtistName) AS artist_count,
        STRING_AGG(DISTINCT GenreArtist, '; ') AS genre_artist_combinations
    FROM playlist_details
    GROUP BY PlaylistId, PlaylistName
),
filtered_playlists AS (
    SELECT * FROM playlist_grouped
    WHERE genre_count >= 3 AND artist_count >= 3
)

SELECT 
    PlaylistId,
    PlaylistName AS Name,
    genre_artist_combinations
FROM 
    filtered_playlists
ORDER BY 
    genre_count DESC, playlistid;
