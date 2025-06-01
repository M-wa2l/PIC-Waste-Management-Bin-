# ♻️PIC-Waste-Management-Bin-
This project is a smart waste management system using the PIC16F877A microcontroller. It sorts waste with an inductive sensor for metals and an IR sensor for other materials, using a servo to direct items into the correct bin. A Sharp IR sensor monitors the bin's fill level, displaying status on an LCD and activating a buzzer when full. A push button triggers a bin emptying mode. The system promotes efficient, automated waste handling.


## 📘 Project Overview

The Smart Waste Management System is an embedded system project designed to automate the detection, sorting, and monitoring of waste using the **PIC16F877A** microcontroller. The goal is to reduce manual labor, improve the efficiency of waste segregation, and promote cleaner and smarter waste disposal practices. By utilizing a combination of sensors, actuators, and display elements, the system intelligently classifies waste and manages the bin’s fill status.

The core functionality revolves around two primary sensors: an **inductive proximity sensor**, which detects metallic waste, and an **IR sensor** for detecting general non-metallic waste. When an item is placed into the system, the microcontroller uses these sensors to determine the type of material. Based on the detection, a **servo motor** is rotated to direct the waste into the appropriate bin—ensuring proper segregation at the source.

In addition to sorting, the system incorporates a **Sharp IR distance sensor** to monitor the fill level of the waste bin. This sensor continuously checks whether the bin is nearing capacity. The current bin status is displayed in real time on a **16x2 LCD**, providing users with visual feedback. When the bin reaches a predefined threshold, a **buzzer** is activated as an alert to notify the user that the bin needs to be emptied.

A **push button** is included to simulate the bin emptying process. When pressed, the system triggers an **interrupt routine** that resets the bin status and returns the servo to its default position. This feature helps in mimicking real-world operations and testing the system's response to external user interaction.

Overall, this project demonstrates the effective integration of sensors, actuators, and microcontroller programming to create a compact and intelligent waste management solution. It is ideal for smart homes, schools, and public places where maintaining hygiene and efficient waste handling is critical. The project also serves as a great educational tool for understanding real-world embedded system applications.


## Features


## 🧰Components Used

- PIC16F877A microcontroller
- Inductive proximity sensor
- IR sensor
- Sharp IR distance sensor
- Servo motor
- LCD (16x2) display
- Buzzer
- Push button
- Resistors, capacitors, and power supply


- ## Simulation
https://github.com/user-attachments/assets/ac2a3ab3-5947-431f-990c-a5d92cf43e0f

*Feel free to contribute or suggest improvements!* 





