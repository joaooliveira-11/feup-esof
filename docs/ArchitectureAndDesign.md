
## Architecture and Design

In this section, our architecture is described in two ways: the logical and physical views.

### Logical architecture

In this subsection we document the high-level logical structure of the code (Logical View), using a UML package diagram.

Porto Explorer is divided in three layers: 
- UI 
- Logic 
- Database 

The user interface (UI) is responsible for rendering the model and facilitating user interactions. It communicates user input to the logic component.

The logic component serves as an intermediary between the UI and the database. It handles user information retrieved from the database, ensuring it is presented in a readable format. Additionally, the logic component has the capability to modify the database as required.

In our application, we integrate two external services: the Google Maps API and Firebase. The Home Page, Details, and Auth Logic modules are interconnected and communicate with the Firebase external service. Both the Home Page and Details Logic, as well as the Map Logic module, interact with the Google Maps API external service.

The database accumulates data from various user activities, providing a central repository for storing and retrieving information.

<p align="center" justify="center">
  <img src="https://github.com/FEUP-LEIC-ES-2022-23/2LEIC10T2/blob/main/images/LogicalView.png"/>
</p>

### Physical architecture

In this subsection we document the high-level physical structure of the software system using a UML deployment diagrams (Deployment View). 

Porto Explorer is installed in the user's smarthphone. It stores information about users using Firebase. The app also uses Google Maps API to get information about maps, ratings and reviews. Finally, we use Local Storage to store the user's preferences regarding the language of the application.

<p align="center" justify="center">
  <img src="https://github.com/FEUP-LEIC-ES-2022-23/2LEIC10T2/blob/main/images/DeploymentView.png"/>
</p>

### Vertical prototype

We have implemented the following features:

- Login
- Sign Up
- Access Google Maps API

<img src="https://i.imgur.com/vEcVLJC.png" width="200" height="400" /> |  <img src="https://i.imgur.com/1Z7Ck3d.png" width="200" height="400" /> | <img src="https://i.imgur.com/Z2JQw59.jpg" width="200" height="400" />

Initially, we explored the dart language implementing the login and sign up functionalities, using for that the google firebase. Besides that, we implemented a simple code to test the basic functionalities of the google maps API.