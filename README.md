# README

- All models have 'deleted_at' column to avoid real deletion from DB, as deleting anything from DB is not the best approach
- no cascade deletion as we don't delete records
- Post model has 'likes_count' column, which inc/dec on each like/dislike. That's made to avoid any calculation from DB side on each GET post.
- use of transactions to avoid non-consistent state of DB
- there is Like table, which has composite primary key (:user_id, :post_id), no :id. That's made for optimisation: use less space, no need in extra indexes. We need this table mostly to know if a user has liked the post
- for tests rspec is used /spec folder 


ToDo:
- get 'user_id' from token
- cover bad cases with unit-tests
- cleanup repository: delete not used folders and files


P.S.
there are 2 indexes in Like which should be removed:
- t.index ["post_id"], name: "index_likes_on_post_id"
- t.index ["user_id"], name: "index_likes_on_user_id"
