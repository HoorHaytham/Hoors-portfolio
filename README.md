# **Quiz Proctoring System** 

## **Project Overview**

The system uses **Prolog, a logical programming language**. It helps assign Teaching Assistants (TAs) to proctor quizzes, ensuring that no TA is assigned to a quiz during their teaching hours or on their day off.

The main goals of this system are:
- Ensure that each TA is available to proctor quizzes based on their schedule.
- Prevent TAs from being assigned to quizzes during their teaching slot or on their day off.
- Assign a sufficient number of TAs to each quiz.

The program takes inputs like TA schedules, quiz details, and teaching slots, and assigns proctors accordingly.

## ⚙️ **Project Requirements**

### 🔑 **Predicates**

The program uses four core predicates:

1. **`assign_proctors/4`**: 
   Assigns proctors to quizzes based on the TA schedules and day off constraints. 
   
2. **`free_schedule/3`**:
   Generates a list of TAs that are available during each time slot.
   
3. **`assign_quizzes/3`**:
   Assigns TAs to quizzes considering their availability.
   
4. **`assign_quiz/3`**:
   Assigns a specific quiz to the required number of free TAs based on their schedule.

### 🖥️ **Input Formats**

- **TAs**: `ta(Name, Day_Off)` where `Day_Off` is the 3-letter abbreviation of the TA's day off (e.g., "tue" for Tuesday).
- **Quizzes**: `quiz(Course, Day, Slot, Count)` where:
  - `Course`: The course code (e.g., `csen403`).
  - `Day`: The day of the quiz.
  - `Slot`: The time slot of the quiz.
  - `Count`: The number of TAs needed.
- **Teaching Schedules**: `day(DayName, DaySchedule)` where `DaySchedule` is a list of time slots with TA names.
- **Proctoring Schedule**: `proctors(quiz(Course, Day, Slot, Count), [List_of_TAs])`.

### 🔄 **Example Usage**

#### 1. **Assigning Proctors**:

```prolog
?- assign_proctors([ta(s,tue), ta(h,tue), ta(m,thu), ta(a,sat)],
[quiz(csen403, sun, 5, 2), quiz(csen401, mon, 2, 3)],
[day(sat, [[], [s], [s], [s], []]),
 day(sun, [[m, h], [], [s, m, h], [h], []]),
 day(mon, [[h], [], [h], [h], []]),
 day(tue, [[], [m], [m], [], [m]]),
 day(wed, [[], [], [m], [m], []]),
 day(thu, [[s], [a, s], [a, s], [a], []])],
ProctoringSchedule).
