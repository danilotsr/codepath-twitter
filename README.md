## Twitter

This is a basic twitter app to read and compose tweets the [Twitter API](https://apps.twitter.com/).

Time spent:

- Assignment 3: 15 hours
- Assignment 4: 10 hours

### Features

#### Required

- [x] User can sign in using OAuth login flow
- [x] User can view last 20 tweets from their home timeline
- [x] The current signed in user will be persisted across restarts
- [x] In the home timeline, user can view tweet with the user profile picture, username, tweet text, and timestamp.  In other words, design the custom cell with the proper Auto Layout settings.  You will also need to augment the model classes.
- [x] User can pull to refresh
- [x] User can compose a new tweet by tapping on a compose button.
- [x] User can tap on a tweet to view it, with controls to retweet, favorite, and reply.
- [x] User can retweet, favorite, and reply to the tweet directly from the timeline feed.

- [x] Hamburger menu
  - [x] Dragging anywhere in the view should reveal the menu.
  - [x] The menu should include links to your profile, the home timeline, and the mentions view.
- [x] Profile page
  - [x] Contains the user header view
  - [x] Contains a section with the users basic stats: # tweets, # following, # followers
- [x] Home Timeline
  - [] Tapping on a user image should bring up that user's profile page

#### Optional

- [x] When composing, you should have a countdown in the upper right for the tweet limit.
- [x] After creating a new tweet, a user should be able to view it in the timeline immediately without refetching the timeline from the network.
- [x] Retweeting and favoriting should increment the retweet and favorite count.
- [ ] User should be able to unretweet and should decrement the retweet count.
- [x] User should be able to unfavorite and should decrement the favorite count.
- [x] Replies should be prefixed with the username and the reply_id should be set when posting the tweet,
- [x] User can load more tweets once they reach the bottom of the feed using infinite loading similar to the actual Twitter client.

- [ ] Implement the paging view for the user description.
- [ ] As the paging view moves, increase the opacity of the background screen. See the actual Twitter app for this effect
- [ ] Pulling down the profile page should blur and resize the header image.
- [ ] Account switching
  - Long press on tab bar to bring up Account view with animation
  - Tap account to switch to
  - Include a plus button to Add an Account
  - Swipe to delete an account

#### Extra

- [x] Persist draft tweet message while it is not posted.
- [x] When replying to a retweet, prefix the new message with two screen names: the original author and the retweeted one.
- [x] Support singular/plural texts for "retweets" and "favorites".
- [x] Clean up persisted state (logged-in user and pending message) on logout.

### Walkthrough


![Video Walkthrough - Assignment 4](./demo-assignment-4.gif)

![Video Walkthrough - Assignment 3](./demo.gif)
