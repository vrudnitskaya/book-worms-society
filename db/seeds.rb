puts "Clearing the database"
Like.destroy_all
Bookmark.destroy_all
Comment.destroy_all
PostTag.destroy_all
TagFollow.destroy_all
Tag.destroy_all
Post.destroy_all
Follow.destroy_all
User.destroy_all

puts "Creating the users"

frodo = User.create!(username: "frodo", email: "frodo@shire.com", password: "ringbearer")
hermione = User.create!(username: "hermione", email: "hermione@hogwarts.com", password: "books4life")
elizabeth = User.create!(username: "elizabeth", email: "elizabeth@pemberley.com", password: "prideandprejudice")
lyra = User.create!(username: "lyra", email: "lyra@oxford.com", password: "alethiometer")
moomin = User.create!(username: "moomin", email: "moomin@valley.com", password: "snorkmaiden")

users = [ frodo, hermione, elizabeth, lyra, moomin ]

puts "Creating tags"

fantasy = Tag.find_or_create_by!(name: "fantasy")
adventure = Tag.find_or_create_by!(name: "adventure")
magic = Tag.find_or_create_by!(name: "magic")
classics = Tag.find_or_create_by!(name: "classics")
love = Tag.find_or_create_by!(name: "love")
philosophy = Tag.find_or_create_by!(name: "philosophy")
nature = Tag.find_or_create_by!(name: "nature")

puts "Creating posts"

post1 = frodo.posts.create!(
  title: "A Long Road with a Book in Hand",
  content: <<~TEXT,
    I didn’t just read "The Lord of the Rings" — I walked beside Sam and carried the Ring with Frodo...
  TEXT
  image_url: "https://m.media-amazon.com/images/I/81XH+m22mjL._AC_UY218_.jpg"
)
PostTag.create!(post: post1, tag: fantasy)
PostTag.create!(post: post1, tag: adventure)

post2 = hermione.posts.create!(
  title: "MuggleNet's Complete Guide to the Fantastic Creatures",
  content: <<~TEXT,
    While I appreciate MuggleNet's Complete Guide to the Fantastic Creatures for its effort to make magical zoology accessible to a broader audience, I must point out a few inaccuracies and oversimplifications...
  TEXT
  image_url: "https://m.media-amazon.com/images/I/81Hi0nihHKL._SY385_.jpg"
)
PostTag.create!(post: post2, tag: magic)
PostTag.create!(post: post2, tag: classics)

post3 = elizabeth.posts.create!(
  title: "Mistakes and Matchmaking",
  content: <<~TEXT,
    Emma is a lesson in how cleverness without self-awareness can lead us astray...
  TEXT
  image_url: "https://m.media-amazon.com/images/I/81vfJi+HAVL._AC_UL320_.jpg"
)
PostTag.create!(post: post3, tag: love)
PostTag.create!(post: post3, tag: classics)

post4 = lyra.posts.create!(
  title: "North, Wind, and Gunpowder",
  content: <<~TEXT,
    Reading Once Upon a Time in the North felt like uncovering a secret page from the world before I knew it...
  TEXT
  image_url: "https://m.media-amazon.com/images/I/916zOx7lJ2L._SY385_.jpg"
)
PostTag.create!(post: post4, tag: adventure)

post5 = moomin.posts.create!(
  title: "The Comet and the Calm Before the Storm",
  content: <<~TEXT,
    In "Comet in Moominland", everything feels like an adventure that’s both exciting and a little bit scary...
  TEXT
  image_url: "https://m.media-amazon.com/images/I/61qmH8Q3Z9L._AC_UY218_.jpg"
)
PostTag.create!(post: post5, tag: adventure)
PostTag.create!(post: post5, tag: philosophy)

puts "Creating follows"
users.combination(2).each do |u1, u2|
  Follow.create!(following_user_id: u1.id, followed_user_id: u2.id)
  Follow.create!(following_user_id: u2.id, followed_user_id: u1.id)
end

puts "Creating comments with replies"
Post.includes(:user).each do |post|
  commenter = (users - [post.user]).sample

  comment = Comment.create!(
    user: commenter,
    post: post,
    content: "I really liked this post!"
  )

  Comment.create!(
    user: post.user,
    post: post,
    parent_comment_id: comment.id,
    content: "Thank you for your feedback!"
  )
end

puts "Creating likes on posts"
users.each do |user|
  Post.all.sample(2).each do |post|
    Like.create!(user: user, likeable: post)
  end
end

puts "Creating likes on comments"
users.each do |user|
  Comment.all.sample(2).each do |comment|
    Like.create!(user: user, likeable: comment)
  end
end

puts "Creating bookmarks"
users.each do |user|
  user_bookmarks = Post.all.sample(2)
  user_bookmarks.each do |post|
    Bookmark.create!(user: user, post: post)
  end
end

puts "Creating tag follows"
users.each do |user|
  Tag.all.sample(2).each do |tag|
    TagFollow.create!(user: user, tag: tag)
  end
end
