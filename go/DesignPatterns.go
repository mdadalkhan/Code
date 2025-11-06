/**
 * @author <mdadalkhan@gmail.com>
 * Date: 03/11/2025 (DD/MM/YYYY) GMT +06:00 15:42
 * */

 /*
 All Design Patterns in Modern Web Development (Including GoF)
This document contains an extensive list of design patterns commonly used in modern web development, including the classic Gang of Four (GoF) design patterns and patterns adapted for modern frontend, backend, and architectural paradigms.
1. Gang of Four (GoF) Design Patterns
Creational Patterns
•	Singleton – Ensure only one instance exists (e.g., database connection pool).
•	Factory Method – Delegate object creation to subclasses.
•	Abstract Factory – Create families of related objects (e.g., UI themes).
•	Builder – Step-by-step object construction (e.g., query builders).
•	Prototype – Clone existing objects instead of creating new ones.
Structural Patterns
•	Adapter – Convert one interface to another (e.g., API response conversion).
•	Bridge – Decouple abstraction from implementation.
•	Composite – Represent part-whole hierarchies (e.g., React component trees).
•	Decorator – Dynamically add behavior (e.g., Express middleware).
•	Facade – Simplify complex subsystems (e.g., database wrapper).
•	Flyweight – Optimize memory for many similar objects (e.g., CSS caching).
•	Proxy – Control access to another object (e.g., authentication proxy).
Behavioral Patterns
•	Chain of Responsibility – Pass requests through handlers (e.g., middleware chains).
•	Command – Encapsulate requests as objects (e.g., Redux actions).
•	Interpreter – Evaluate grammar or language (e.g., template engine).
•	Iterator – Sequential access to elements (e.g., JS iterators).
•	Mediator – Centralize complex communications (e.g., event bus).
•	Memento – Save and restore state (e.g., undo/redo).
•	Observer – Notify dependents of state change (e.g., React reactivity).
•	State – Change behavior based on internal state (e.g., auth flow).
•	Strategy – Switch algorithms dynamically (e.g., sort/filter strategies).
•	Template Method – Define skeleton, defer steps to subclasses (e.g., request pipeline).
•	Visitor – Add new operations to structures (e.g., AST traversal).
2. Modern Web Development Patterns
Frontend Patterns
•	Component-based architecture – Build UI from reusable components (React, Vue, Svelte).
•	Container–Presentational pattern – Separate logic from UI rendering (React/Redux).
•	Hooks pattern – Reuse logic in function components (React hooks).
•	MVVM – Reactive separation between View and Model (Vue, Angular).
•	Flux/Redux – Unidirectional data flow pattern.
•	Observer/Reactive pattern – Automatic UI updates (RxJS, Svelte reactivity).
•	Render Props / HOC – Reusable UI logic (React).
•	Atomic Design – Systematic UI design for component libraries.
Backend Patterns
•	MVC (Model–View–Controller) – Separation of concerns (Laravel, Django).
•	Repository pattern – Abstract data persistence (Knex, TypeORM).
•	Dependency Injection – Manage dependencies explicitly (NestJS, Spring Boot).
•	CQRS – Separate read and write models for scalability.
•	Event Sourcing – Store system events as source of truth.
•	Middleware pipeline – Process requests in layers (Express, Fastify).
•	DTO (Data Transfer Object) – Structured API responses.
Architectural Patterns
•	Microservices – Split into independent deployable services.
•	Monolithic – Single deployable application structure.
•	Serverless – Functions as a service (AWS Lambda, Cloudflare Workers).
•	Event-driven architecture – Asynchronous event-based system.
•	Hexagonal (Ports and Adapters) – Decouple core business logic from infrastructure.
•	Clean Architecture – Layered system emphasizing independence of logic.
•	Domain-Driven Design (DDD) – Code models domain logic closely.
•	Micro Frontends – Independent frontend modules for large SPAs.
•	Progressive Web App (PWA) – Offline-capable web app architecture.
API & Network Patterns
•	API Gateway – Central access to multiple microservices.
•	Backend for Frontend (BFF) – Custom APIs per frontend client.
•	GraphQL Resolver – Field-level dynamic data retrieval.
•	Cache-aside / Read-through – Improve performance with caching (Redis).
•	Circuit Breaker – Prevent cascading service failures.
•	Retry & Backoff – Ensure reliability in API communication.
•	Rate Limiting / Throttling – Control API usage and prevent abuse.
Security Patterns
•	JWT Authentication – Stateless token-based authentication.
•	OAuth 2.0 / OpenID Connect – Secure delegated authentication.
•	RBAC – Role-based access control for users.
•	Data Validation & Sanitization – Protect against input attacks.
•	Zero Trust – Multi-layered security model.
DevOps & Deployment Patterns
•	Blue-Green Deployment – Seamless deployment with zero downtime.
•	Canary Release – Gradual rollout to a subset of users.
•	Immutable Infrastructure – Consistent reproducible deployments.
•	Infrastructure as Code (IaC) – Automated setup using Terraform, Ansible.
•	12-Factor App – Best practices for cloud-native app design.

 */