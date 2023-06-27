
## Requirements

### User stories

Check Github issues labeled as "user story".

### Domain model

In this section the Domain Model that represents the different classes and their relationship with each other.

<p align="center" justify="center">
  <img src="https://github.com/FEUP-LEIC-ES-2022-23/2LEIC10T2/blob/main/images/uml.png"/>
</p>

In order to use the Porto Explorer application, authentication is required. For this, from each user we store the email, name, username, password, score and if the user wishes, a profile picture.
The user's score is acquired through the accumulated points of interests.

Through an integration between the google maps API, users can explore several places of which it is relevant, for the operation of the application, store the name, the place description, the API reviews and the user reviews, in a range of integers from 1 to 5.
Finally, after users visit the various points of interest in Porto, they mark the place as visited, giving it a rating recording the date of visiting in the database.

### UI Mockup

Link to Figma full UI Mockup: https://www.figma.com/file/CXM014twEHdYSjfNY5a56O/Porto-Explorer---ESOF?node-id=31%3A29&t=9W1MlEEY9vGmDVw9-1
