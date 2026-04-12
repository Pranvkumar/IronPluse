# **Project Title: IronPulse Pro \- Gym Membership Management System**

## **1\. Project Overview**

IronPulse Pro is a Java-based application designed to streamline the operations of a modern fitness center. It focuses on managing member lifecycles, diversifying membership plans, and tracking financial transactions through an Object-Oriented approach.

## **2\. Core OOP Implementation Goals**

* **Encapsulation:** Protecting sensitive member data and payment records using private fields and public getters/setters.
* **Inheritance:** Creating a base MembershipPlan class with specialized subclasses (e.g., StudentPlan, CorporatePlan, VIPPlan).
* **Polymorphism:** Implementing a unified calculateBilling() method that behaves differently based on the plan type.
* **Abstraction:** Using Interfaces or Abstract Classes for payment gateways and notification services.

## **3\. Functional Requirements**

### **A. Member Management**

* Register new members with unique IDs.
* Store contact details, age, and joining date.
* Update or deactivate memberships.

### **B. Plan Management**

* Support for multiple tiers: Basic, Premium, and Elite.
* Ability to set duration (Monthly, Quarterly, Annual).
* Automated discount logic for specific member types.

### **C. Payment Tracking**

* Log payments with timestamps.
* Track "Paid" vs "Pending" status.
* Generate basic digital receipts/invoices.

### **D. Reporting (Bonus)**

* View total active members.
* Calculate monthly revenue.

## **4\. Technical Stack**

* **Language:** Java (JDK 11+)
* **Storage:** Initially In-memory (ArrayLists/HashMaps) with potential for File I/O (txt/csv).
* **Interface:** Console-based CLI (Command Line Interface).

## **5\. System Use Cases**

1. **Admin Login:** Access to the management dashboard.
2. **Add Member:** Input details and assign a plan.
3. **Process Payment:** Log a transaction for an existing member.
4. **View Dashboard:** Summary of gym statistics.
