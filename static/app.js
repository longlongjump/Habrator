
var Post = Backbone.Model.extend({
});
var Posts = Backbone.Collection.extend({
  model: Post,
  url:'/posts'
});


var PostsView = Backbone.View.extend({

  render: function() {
    self = this;
    this.$el.html("");
    this.posts.each( function(item) {
      self.$el.append(_.template( $("#post_template").html(), item.toJSON()));
    });
  }
});

$(function() {
  var post_view = new PostsView({el:$('.container-main').eq(0)});
  post_view.posts = new Posts();
  post_view.posts.bind('reset',_.bind(post_view.render, post_view));
  post_view.posts.fetch();

  //window.setInterval(_.bind(post_view.posts.fetch,post_view.posts), 10000);
});
