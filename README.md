# QuickFork Development Report

Welcome to the documentation pages of the QuickFork!

You can find here details about the QuickFork, from a high-level vision to low-level implementation decisions, a kind of Software Development Report, organized by type of activities:

* [Business modeling](#Business-Modelling)
  * [Product Vision](#Product-Vision)
  * [Features and Assumptions](#Features-and-Assumptions)
  * [Elevator Pitch](#Elevator-pitch)
* [Requirements](#Requirements)
  * [Domain model](#Domain-model)
* [Architecture and Design](#Architecture-And-Design)
  * [Logical architecture](#Logical-Architecture)
  * [Physical architecture](#Physical-Architecture)
  * [Vertical prototype](#Vertical-Prototype)
* [Project management](#Project-Management)

Contributions are expected to be made exclusively by the initial team, but we may open them to the community, after the course, in all areas and topics: requirements, technologies, development, experimentation, testing, etc.

Please contact us!

Thank you!

*António Abílio* (up202205469@up.pt)

*Gonçalo Nunes* (up202205538@up.pt)

*Tiago Pinheiro* (up202207890@up.pt)

*Tiago Rocha* (up202206232@up.pt)

*Vanessa Queirós* (up202207919@up.pt)

---
## Business Modelling

### Product Vision

Skip the line, save time. A revolutionary app designed to transform the canteen experience at FEUP by simplifying the queuing process. Our vision is to create an organized and efficient platform that’s not only user-friendly but also allows students to maximize their time.

### Features and Assumptions
- Buy canteen tickets - Purchase canteen tickets effortlessly without needing physical copies and wainting in the line.
- Consult canteen menus - Easily view menus for specific days to decide on purchasing tickets.
- Payment with card and MB Way - Pay for tickets using either card or MB Way, ensuring a smooth transaction process.
- Save payment methods - Store your preferred payment methods for future purchases, to improve the buying process.
- Consult bought meals - Check previously purchased meals to stay organized and keep track of your history.
- Validation of tickets - Enable workers to validate tickets within the app, ensuring a safe and efficient process.
- Login with SIGARRA credentials - Log in using SIGARRA credentials, simplifying access and providing a faster login experience for users.

### Elevator Pitch
Hi! I'm part of a group of students that is developing an app that will allow for faster lines at FEUP's canteen. Currently if you go to the canteen you'll find that most of the time spent before being able to get your food is waiting in the queue and buying the food's ticket.

Our flutter app provides the solution to this while being easy to use. Just use your already existing Sigarra's login and associate your prefered payment method, either using MbWay or using your debit/credit card. After this you'll be able to access our shop from where you can select which ticket you wanna buy. Finally, in the canteen, when you're asked to, just click the bought ticket and show it.

That's it, if you are a user of FEUP's canteen you'll surelly love our app.

"So, how much time do you spend on the queues?"


## Requirements

### Domain model

<p align="center" justify="center">
  <img src="https://github.com/FEUP-LEIC-ES-2023-24/2LEIC18T2/blob/b3850ba15a4176be8e03639a0955b117643e0ebf/images/DomainModel.png?raw=true"/>
</p>

For every ticket there is an ID, Date, a boolean to check if it is a lunch or dinner, the kind of meal and another boolean to check if it has already been used. The ticket can only exist if it has been paid.

One user can buy many tickets, related to the user by their UpNumber, name and email address.

The user can be either a student or an employee. From the student it is relevant to know the year and the degree they are on. As for the employee, their function must be known.

The ticket can be bought by the user using MbWay or a credit card, and it needs to be validated by the employee.


## Architecture and Design

### Logical architecture

<p align="center" justify="center">
  <img src="https://github.com/FEUP-LEIC-ES-2023-24/2LEIC18T2/blob/becca77738264bed0cfa3b8cc3a72b8dd9e52ebc/images/LogicalView.png?raw=true"/>
</p>

App UI is used to view the application pages;

App Business Logic is used to manage and alter the user's data

App Database Scheme is where some of the data off the app is stored

Sigarra is an external database that has the information about the student/worker.

Payment Gateway is the method that allows the transation to occur between the bank of the buyer and the canteen shop.

### Physical architecture

<p align="center" justify="center">
  <img src="https://github.com/FEUP-LEIC-ES-2023-24/2LEIC18T2/blob/becca77738264bed0cfa3b8cc3a72b8dd9e52ebc/images/DeploymentView.png?raw=true"/>
</p>

The physical architecture diagram shows five nodes that represent the physical components of our app and how they are connected.

The first node is the "Students SmartPhone", represented by the APP_FLUTTER component, which is used to access the app using the BUYER_UI.

The second one is the "Workers SmartPhone", represented by the APP_FLUTTER component, which is used to access the app using the CHECKER_UI.

The third is the "Application Server" that makes the connection between the UIs and logical and checking services, which then connects to the Database, while also accessing the required external entities.

The fourth node is the "Bank Server", represented by the BANK_API, which is used to access external information related to the user's bank account.

The fifth one is the "Sigarra Server", represented by the SIGARRA_API, which is used to access external information related to the user's Sigarra account.

### Vertical prototype
<p align="center" justify="center">
  <img src="https://github.com/FEUP-LEIC-ES-2023-24/2LEIC18T2/blob/b2394cff3a2616ee6fd7914d7a1fe62c523f75ca/images/Prototype.jpeg?raw=true" width="50%"/>
</p>

**Talvez pequena descrição aqui**

## Project management

**Não percebo bem o que é para pôr aqui**
