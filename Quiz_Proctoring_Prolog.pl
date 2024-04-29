/*In this project you are going to implement a Prolog program to assign TAs to proctor quizzes based on their teaching schedule. There are quizzes at
different timings during the week and each quiz needs a specific number of proctors.
There might also be multiple quizzes during the same slot. These proctors are TAs but
they cannot be assigned to a quiz on a slot that they also teach on. They also cannot
be assigned to proctor a quiz on their day off. Therefore, we need a system to find any
possible assignments of TAs to quizzes, verify a given assignment or output false if no
assignment is possible.
-Each quiz needs a given number of proctors.
-No TA can be assigned to proctor at the same time as a teaching slot.
-No TA can be assigned to proctor on their day-off.
-A TA cannot be assigned to two quizzes during the same slot.
 > quiz(Course, Day, Slot, Count) 
 >TeachingSchedule a list of 6 day structures day(DayName, DaySchedule) 
 >ProctoringSchedule where proctoring schedule has each quiz assigned a list
of TA names to proctor it.Example:[proctors(quiz(csen403, sat, 1, 2), [m, h]),proctors(quiz(csen401, mon, 5, 3), [m, a, h])] 
 >FreeSchedule is formatted the same as TeachingSchedule */


assign_proctors(AllTAs, Quizzes, TeachingSchedule, ProctoringSchedule):-
free_schedule(AllTAs,TeachingSchedule,FreeSchedule),!,
assign_quizzes(Quizzes,FreeSchedule,ProctoringSchedule).

free_schedule(_,[],[]).
free_schedule(AllTAs,[day(Day,DaySchedule)|RestOfDays],[day(Day,FS)|RestOfDays2]):-
	given_day_FS(AllTAs,Day,DaySchedule,FS),
	free_schedule(AllTAs,RestOfDays,RestOfDays2).
	
	 /*iterates over Slots to find free TAs schedule of a given day passed from free_schedule*/
	given_day_FS(_,_,[],[]).
	given_day_FS(AllTAs,Day,[Slot|RestOfSlots],[FreeTAsPermuted|FreeTAsOfRemainingSlots]):-
		find_free_TAs(AllTAs,Day,Slot,[],FreeTAs),permutation(FreeTAs,FreeTAsPermuted),
		given_day_FS(AllTAs,Day,RestOfSlots,FreeTAsOfRemainingSlots).
		
		/*iterates over TAs given a specific slot on a specific day, and finds free TAs of a specific slot*/
		 find_free_TAs([],_,_,FreeTAs,FreeTAs).
		
		find_free_TAs([ta(Name,Off)|RestOfTAs],Day,Slot,Acc,FreeTAs):-
			(Off=Day;member(Name,Slot)),
			find_free_TAs(RestOfTAs,Day,Slot,Acc,FreeTAs).
			
		find_free_TAs([ta(Name,Off)|RestOfTAs],Day,Slot,Acc,FreeTAs):-
			Off\=Day,\+member(Name,Slot),
			find_free_TAs(RestOfTAs,Day,Slot,[Name | Acc],FreeTAs).


assign_quiz(quiz(_,Day,Slot,Count),FreeSchedule,AssignedTAs):-
			%returns_DaySchedule 
			member(day(Day,DaySchedule),FreeSchedule),
			nth1(Slot,DaySchedule,TAsAvailable),
			length(TAsAvailable,C),find_possible_comb(C,Count,TAsAvailable,Combination),permutation(Combination,AssignedTAs).
			
			find_possible_comb(C,C,TAsAvailable,TAsAvailable).
			find_possible_comb(C,Count,TAsAvailable,Combination):-
				C>Count,combination(TAsAvailable,Count,Combination).
			
			combination(_,0,[]).
			combination([TA|RestOfTAs],Count,[TA|Combination]):-
				Count>0, C is Count-1,combination(RestOfTAs,C,Combination).
			combination([_|RestOfTAs],Count,Combination):-
				Count>0,combination(RestOfTAs,Count,Combination).



assign_quizzes([],_,[]).
		assign_quizzes([Quiz|RestOfQuizzes],FreeSchedule,[proctors(Quiz,AssignedTAs)|RestOfProctoringSchedule]):-
				assign_quiz(Quiz,FreeSchedule,AssignedTAs),
				deleteAssigned(AssignedTAs,Quiz,FreeSchedule,NewFreeSchedule),
				assign_quizzes(RestOfQuizzes,NewFreeSchedule,RestOfProctoringSchedule).                       
			
			deleteAssigned([],_,Updated,Updated).
			deleteAssigned([TA|RestOfTAs],quiz(_,Day,Slot,_),FreeSchedule,NewFreeSchedule):-
					member(day(Day,DaySchedule),FreeSchedule),
					nth1(Slot,DaySchedule,TAsAvailable),delete(TAsAvailable,TA,UpdatedTAs),constructUpdatedFreeSchedule(UpdatedTAs,Day,Slot,DaySchedule,FreeSchedule,UpdatedFreeSchedule),
					deleteAssigned(RestOfTAs,quiz(_,Day,Slot,_),UpdatedFreeSchedule,NewFreeSchedule).
			
			 constructUpdatedFreeSchedule(UpdatedTAs,Day,Slot,DaySchedule,FreeSchedule,UpdatedFreeSchedule):-
				      %updateDaySchedule
					updateDaySchedule(Slot,UpdatedTAs,DaySchedule,UpdatedDaySchedule),
					UpdatedDay=day(Day,UpdatedDaySchedule),
					  %updateFreeSchedule
					updateFreeSchedule(UpdatedDay,FreeSchedule,UpdatedFreeSchedule). 
				
				
				updateDaySchedule(Slot,UpdatedTAs,DaySchedule,UpdatedDaySchedule):-
					updateDaySchedule_H(Slot,UpdatedTAs,DaySchedule,[],UpdatedDaySchedule).
					
				updateDaySchedule_H(Slot,UpdatedTAs,[_|T],Acc,UpdatedDaySchedule):-
						Slot=1,append(Acc,[UpdatedTAs],A),append(A,T,UpdatedDaySchedule).
				
				updateDaySchedule_H(Slot,UpdatedTAs,[H|T],Acc,UpdatedDaySchedule):-
						Slot>1,S is Slot-1,append(Acc,[H],A),
						updateDaySchedule_H(S,UpdatedTAs,T,A,UpdatedDaySchedule).
				
				updateFreeSchedule(UpdatedDay,FreeSchedule,UpdatedFreeSchedule):-
					return_UpdatedFS(FreeSchedule,UpdatedDay,[],UpdatedFreeSchedule).
				
				
				return_UpdatedFS([day(Day,_)|T],day(Day,UpdatedDaySchedule),Acc,UpdatedFreeSchedule):-
				      append(Acc,[day(Day,UpdatedDaySchedule)],A),
					  append(A,T,UpdatedFreeSchedule).

					  
				return_UpdatedFS([day(Day,DaySchedule)|T],day(Day1,UpdatedDaySchedule),Acc,UpdatedFreeSchedule):-
					Day\=Day1,append(Acc,[day(Day,DaySchedule)],A),return_UpdatedFS(T,day(Day1,UpdatedDaySchedule),A,UpdatedFreeSchedule).
	
