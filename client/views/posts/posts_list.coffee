Template.postsList.helpers
  postsWithRank: ->
    @posts.rewind()
    @posts.map (post, index, cursor) ->
      post._rank = index
      post