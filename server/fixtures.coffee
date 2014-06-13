if Posts.find().count() is 0
  now = new Date().getTime()
  # create two users
  tonesId = Meteor.users.insert(profile:
    name: "Tony Chen"
  )

  tones = Meteor.users.findOne(tonesId)

  dankId = Meteor.users.insert(profile:
    name: "Dank Nug"
  )

  dank = Meteor.users.findOne(dankId)

  testId = Posts.insert(
    title: "bsc hackerspace @ cloyne"
    userId: tones._id
    author: tones.profile.name
    url: "http://bsc.coop"
    submitted: now - 7 * 3600 * 1000
  )

  Comments.insert(
    postId: testId
    userId: dank._id
    author: dank.profile.name
    submitted: now - 7 * 3600 * 1000
    body: "Test comment new post"
  )