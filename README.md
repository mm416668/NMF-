# NMF-

This project is based on NMF algorithm to design and test recommender system

For test and design purpose, I will start with Movielen Latest Dataset (small version). It contains 100004 ratings and 1296 tag applications across 9125 movies. These data were created by 671 users between January 09, 1995 and October 16, 2016. This dataset was generated on October 17, 2016.
I choose three factors: User, Movie and Time in this project. I will sue Tags.csv, Ratings and Movie.csv three datasets.
For column in those three datasets:
Ratings: userId,movieId,rating,timestamp
Tags: userId,movieId,tag,timestamp
Movies: movieId,title,genres

APPROACH
Non-negative matrix factorization (NMF or NNMF), also non-negative matrix approximation [1][2] is a group of algorithms in multivariate analysis and linear algebra where a matrix V is factorized into (usually) two matrices W and H, with the property that all three matrices have no negative elements. This non-negativity makes the resulting matrices easier to inspect. Also, in applications such as processing of audio spectrograms or muscular activity, non-negativity is inherent to the data being considered. Since the problem is not exactly solvable in general, it is commonly approximated numerically. (Wikipedia, 2018)
