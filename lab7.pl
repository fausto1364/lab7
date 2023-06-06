add_date(Date, DaysToAdd, Result) :-
    date_to_list(Date, DD, MM),
    days_in_month(MM, Temp_Days),
    add_days(MM, DD, Temp_Days, DaysToAdd, MM_new, DD_new),
    format_output(MM_new, DD_new, Result).

sub_date(Date, DaysToSub, Result) :-
    date_to_list(Date, DD, MM),
    sub_days(MM, DD, DaysToSub, MM_new, DD_new),
    format_output(MM_new, DD_new, Result).
    
format_output(MM_new, DD_new, Result) :-
    (   DD_new < 10 ->
        atom_number(DDAt, DD_new),
        atom_concat('0',DDAt, DDAtom)
    ;	DD_new >= 10 ->
        atom_number(DDAtom, DD_new)
    ),
    (   MM_new < 10 ->
        atom_number(MMAt, MM_new),
        atom_concat('0',MMAt, MMAtom)
    ;	MM_new >= 10 ->
        atom_number(MMAtom, MM_new)
    ),
    atom_concat(DDAtom, MMAtom, Result).
    
date_to_list(Date, DD, MM) :-
    atom_chars(Date, [D1, D2, M1, M2]),
    char_code(D1, Code1),
    char_code(D2, Code2),
    char_code(M1, Code3),
    char_code(M2, Code4),
    DD is (Code1 - 48) * 10 + (Code2 - 48), % some ascii conversion
    MM is (Code3 - 48) * 10 + (Code4 - 48).

days_in_month(MM, Temp_Days) :-
    % days of months in 2023
    (   member(MM, [1, 3, 5, 7, 8, 10, 12]) ->
        Temp_Days = 31
    ;   member(MM, [4, 6, 9, 11]) ->
        Temp_Days = 30
    ;   MM = 2 ->
        Temp_Days = 28
    ).

add_days(MM, DD, Temp_Days, DaysToAdd, MM_new, DD_new) :-
    (   DD + DaysToAdd =< Temp_Days ->
        DD_new is DD + DaysToAdd,
        MM_new= MM
    ;   DD + DaysToAdd > Temp_Days ->  
        MM_new is MM + 1,
        DaysToAdd_new is DaysToAdd - (Temp_Days - DD),
        DD_new = DaysToAdd_new
    	% this would have to be updated to a recursive version for days to be exceeding two months. 
    ).

sub_days(MM, DD, DaysToSub, MM_new, DD_new) :-
    (   DD - DaysToSub >= 1 ->
        DD_new is DD - DaysToSub,
        MM_new = MM
    ;   DD - DaysToSub < 1 ->  
        MM_new is MM - 1,
        DaysToSub_new is DaysToSub - DD,
        days_in_month(MM_new, Temp_Days_new),
        DD_new is Temp_Days_new - DaysToSub_new
    	% this would have to be updated to a recursive version for days to be exceeding two months. 
    ).
