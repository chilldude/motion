if Posts.find().count() is 0
    now = new Date().getTime()
    
    # create two users
    tonesId = Meteor.users.insert profile:
        name: "Tony Chen"

    tones = Meteor.users.findOne(tonesId)

    dankId = Meteor.users.insert profile:
        name: "Dank Nug"

    dank = Meteor.users.findOne(dankId)

    Posts.insert
        title: "bsc hackerspace @ cloyne"
        author: "mitar"
        url: "http://bsc.coop"

    Posts.insert
        title: "png connor braa"
        author: "connor braa"
        url: "http://casa-z.org"

    Posts.insert
        title: "Sky bridge"
        author: "Tony chen"
        url: "http://casa-z.org"
