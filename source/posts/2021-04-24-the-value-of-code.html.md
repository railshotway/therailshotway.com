---
title: 'The Value of Code'
date: 2021-04-24 19:44 UTC
author: avi_flombaum
tags:
  - history
  - values
  - philosophy
published: true
---

In 1989 Sir Tim Berners-Lee began working on a set of technologies that came together to become what is today known as The Web and even the Internet. At its essence, the Web is a global, decentralized, application architecture allowing any computer connected to the internet to serve an application in the form of HTML documents and client-side code over HTTP/S rendered by browsers, which today are powerful graphical and interpreter engines. 

The Web thus represents the most ubiquitous and robust software platform in history. What started as simple HTML documents that could hyperlink to other HTML documents, thereby weaving the web together, now delivers the biggest networked applications in history. Trillions of dollars of value have been created by these applications and endless amounts of social good has been accomplished. 

The Web has done nothing short of change the world and humanity forever. The value of code is the ability to build web applications that make the world a better place.
  
## First Principle: Make Meaning

Programming is the art and science of giving computers instructions. As computers, the internet, and the Web have matured, the type of applications built have grown in complexity. To solve for this, programmers have created a plethora of incredibly helpful languages, libraries, and patterns. To make the development of software easier is to unleash the creativity of millions and allow individuals, communities, and companies to manifest their dreams and ambitions through their code.

> “How do we convince people that in programming simplicity and clarity – in short: what mathematicians call elegance – are not a dispensable luxury, but a crucial matter that decides between success and failure?” Edgar Dijkstra
 
The craft of code can be incredibly engaging. Those moments of frustration, followed by the catharsis of solution, the epiphanies of understanding, the marvel at a beautiful implementation pattern, what mathematicians call elegance, and the profound flow states reached, make writing code an intoxicating experience. So much so that software developers can engage in some of the most heated, antagonistic, and caustic battles on the internet over both important and trivial aspects of code.

While everyone is free to have their individual preferences on what is best, I have always reached for a first principle when thinking about how I write code and how I review the code of my students and team. My first principle is to evaluate code on what I feel is the most important, the most central tenet of the craft, which is paradoxically not the code at all, but the value of the end product. The product I am building is more important to me than how I build it. I care about my code, about languages, frameworks, patterns, and workflows only to the extent that they can help me deliver and ship software reliably. 

If the value in code is rooted in the value of software, code is meaningful because the software we create with it is is meaningful. After 20 years as a software developer, 15 years of managing hundreds of developers on my teams, 10 years teaching over 5,000 how to code and getting them jobs, I believe the following 2nd order value most serves creating meaning with code. 

## Second Order: Speed is Everything

Speed is everything. The faster you can implement an idea, the quicker you can iterate, the more iterations, the better the result. Every great person I know in any field is an expert in being fast. There is no talent, there are only people that have failed a lot, kept trying, got feedback, made improvements, gained experience, and after years of this, found success. It's simple. If you can try more approaches, an order of magnitude more, in the same time someone else can try one, you are more likely to land on the best one.

I remember watching one of the most talented product designers in the world use Photoshop fifteen years ago. At that point I too fancied myself an adequate designer but always found my time in Photoshop cumbersome. I lacked a fluidity with the tool and my designs took me time to make and my organization of the UI elements made making updates hard. Eventually, I would just stop designing in Photoshop and rely on my ability to design directly in code. As fluent as I was in HTML and CSS, I could never really easily play with different aesthetics and would rely on low-fidelity wireframes and sketches to iterate with and then move into code. I always knew that this was holding me and the value of my software back and have been luckily enough to work with some incredibly professional and fast designers. But watching my friend use Photoshop when he was just 22, he was as fluid and smooth with it as I was in my code editor and terminal. Moving between layers, making global edits to design elements and themes, and trying different concepts with the smoothness and speed of water flowing unincumbered down a river. He wasn't famous or rich then, but I knew watching how he worked that he would make and design some of the most important and innovative products in the future.

To speed there is the speed of development, impacted by the ease of the tools you choose to solve the problems presented by your application. Additionally, there is the speed of the system itself as different languages and frameworks have different implications to how fast your software can be delivered. Finally, there is the speed of your team, how fast are they in these tools, how quickly can they learn and adopt best practices, and how well the ecosystem supports painless collaboration.

I choose the tools and patterns that most directly impact speed because speed will most directly contribute to my code's value creation, and that is what really matters. I don't care about using the fancy new library. I don't care about needless migrations to newer framework versions just because. I don't care about using the fastest language if a language more suited for the problem domain is fast enough to the end user. I don't care about being cool, trendy, or fancy. I just want me and my team to be fast because that is what signals to me that we are focused on the what's actually important - making great products.

## Third Factors

The values I have found that most impact the speed of my software development, my teams contributions, and the response of the application are, in no particular order:

- Stability
- Maintainability
- Extensibility
- Compatibility
- Ubiquity
- Interoperability
- Simplicity

### Stability

Stability in software is the integrity of the system. How often are bugs or regressions introduced? How often does the system crash? How often is an issue mysteriously here today but gone tomorrow? How reliably and timely are security and optimization patches provided by the maintainers? I favor tools that demonstrate stability because with stability my software can be developed smoothly, and what is smooth will easily become fast.

### Maintainability 

Creating with code carries with the burden of maintenance. Someone will have to be responsible for ensuring that the software continues to perform and can be updated otherwise the value created will dissipate with age. I value how maintainable my software will be and favor choices that are tried and true and have clear and tested paradigms for maintenance. If I can maintain my system unincumbered, I can focus on improving my codebase quickly and get back to the important task of quickly iterating on new concepts and features.

### Extensibility

As the needs of my software change, I want to choose tools that allow for easy additions of logic and data to create new features. I value tools that are built to be compatible with the future. These tools that seek to embrace the best of new ideas allow me to push my applications further. Features like version control, database migrations, clear patterns for where new features go, proper semantic versioning, easy upgrade paths, evolving standard libraries, and conventions over configurations, provide me with the extensibility for my software to continue growing without necessarily growing the complexity. 

### Compatibility

Languages and frameworks that provide compatibility with numerous development environments, platforms like the web, Android, iOS, and Desktop, and other language ecosystems allow for frictional adoptions, integrations, and collaborations. When it's easy to augment your application with support systems like Amazon Web Services, micro-services written in other languages, even ingest modules and components written in other languages directly into your application, you are never really constrained by your main language or framework choice. Closed languages and ecosystems that force you to use only what's available within itself will limit your ability to deliver as your needs change. 

### Ubiquity

Tools that are commonly available means finding support and infrastructure for your software will be easy. Languages that are standard on most systems, even when the OEM version isn't the best (I'm looking at you Ruby that ships with OSX), makes building your code on new systems somewhat less painless. The less you have to support your environment because it is a known and regular setup, preferably one that requires little customization for base performance and productivity, the better. While niche languages are interesting, I tend to favor ones that I know have proliferated far and wide in the systems and programming communities.

### Interoperability 

Silos of information and functionality limit your software's ability to provide value by locking its usage to its own environment and interfaces. But beyond choosing tools that allow your software to freely exchange and make us of functionality and data from other systems, interoperability should also be considered from the perspective of how easily you can entirely move a part of your software to another language and ecosystem. Tools that make major migrations and refactoring across languages and platforms natural should be preferred over those that will lock you in and require a full and everlasting commitment to their stacks. 

### Simplicity

> “The tools we use have a profound and devious influence on our thinking habits, and therefore on our thinking abilities.” Edsger Dijkstra

Finally, I value code that is simple. I find that languages designed to value simplicity, that value readability, that encourage and model code that says what it does over how it does it, lead me to write simpler code. The tools we use will define how we think. In this sense, the values of the tool should mirror the values you have as a developer. Simplicity comes from pattern recognition, from seeing clear similarities between one implementation and another. Code that is proportionate to the problem is easy to understand. Tools that have the integrity needed to accomplish a job means that you can reliably use them thereby simplifying and limiting the choices you need to make. The beauty of code is when it is simple, clear, proportionate, and of high integrity. Favor simplicity as it will increase your speed and that will allow you to make meaningful software.

## Happiness

> “The goal of Ruby is to make programmers happy. I started out to make a programming language that would make me happy, and as a side effect it’s made many, many programmers happy.
> 
> I hope to see Ruby help every programmer in the world to be productive, and to enjoy programming, and to be happy. That is the primary purpose of Ruby language.” Yukihiro Matsumoto

In the end, making meaningful software requires a certain amount of pleasure and happiness. It's rare to see programming languages and frameworks value the human condition. The ergonomics of the tools you use, how it feels to use them, how comfortable they are, is crucial. Without tools and languages that make you happy, programming will be an exercise in frustration. Pain from programming will bleed into your product and code and syphon away the meaning of your software, both in how meaningful it felt to make and the meaning it will have for people. The value of code is to feel meaningful while making meaning.