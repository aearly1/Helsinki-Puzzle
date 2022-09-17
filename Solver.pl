%UNRELATED TO PROJECT PARTS. IT'S JUST A HELPER TOOL. I USE THEM AS HELPER PREDICATES

insert_last(X,[],[X]).
insert_last(X,[H|T],[H|R]):- insert_last(X,T,R).

mem(X,[X|_]).
mem(X,[H|T]):- H\=X, mem(X,T).

length1([],0).
length1([_|T],L):- length1(T,L1),L is L1+1.

%PART 1: GRID_BUILD/2
grid_build(N,M):- grid_build_helper(N,N,[],M).

grid_build_helper(_,0,Acc,Acc).
grid_build_helper(N,Count,Acc,M):- Count\=0, length(L,N), insert_last(L,Acc, New_Acc), New_Count is Count-1, grid_build_helper(N,New_Count,New_Acc,M).

%PART 2: GRID_GEN/2
grid_gen(N,M):- grid_build(N,Grid), grid_gen_helper(N,Grid,M).

grid_gen_helper(_,[],[]).
grid_gen_helper(N,[H|T],[New_H|R]):- fill_in_row(N,H,New_H), grid_gen_helper(N,T,R).

fill_in_row(_,[],[]).
fill_in_row(N,[_|T],[X|R]):- valid_num(N,1,X), fill_in_row(N,T,R).

valid_num(X, Count, Count):- Count=<X.
valid_num(X, Count, Num):- Count=<X, New_Count is Count + 1, valid_num(X,New_Count,Num).

%PART 3: NUM_GEN/3
num_gen(L,L,[L]).
num_gen(F,L,[F|R]):- F<L, Next is F + 1,num_gen(Next,L,R).

%PART 4: CHECK_NUM_GRID/1
find_max_in_row([],Max,Max).
find_max_in_row([H|T],Max,Result):- H>Max, find_max_in_row(T,H,Result).
find_max_in_row([H|T],Max,Result):- H=<Max, find_max_in_row(T,Max,Result).

find_max_in_grid([],Max,Max).
find_max_in_grid([H|T],Max,Result):- find_max_in_row(H,1,RowMax), RowMax>Max, find_max_in_grid(T,RowMax,Result).
find_max_in_grid([H|T],Max,Result):- find_max_in_row(H,1,RowMax), RowMax=<Max, find_max_in_grid(T,Max,Result).

check_num_grid(G):- length1(G,Size), find_max_in_grid(G,1,Max),  Max=<Size, num_gen(1,Max,Needed_Numbers), check_num_grid_Helper1(Needed_Numbers,G).

check_num_grid_Helper1([],_).
check_num_grid_Helper1([H|T],G):- find_num_in_grid(H,G), check_num_grid_Helper1(T,G).

find_num_in_grid(N,[H|_]):- mem(N,H).
find_num_in_grid(N,[H|T]):- \+mem(N,H), find_num_in_grid(N,T).

%PART 5: ACCEPTABLE _PERMUTATIONS/2
acceptable_permutation(L,R):- permutation(L, R), compare_elements(L,R).

compare_elements([],[]).
 compare_elements([H1|T1],[H2|T2]):- H1\=H2,  compare_elements(T1,T2).

%PART 6: ACCEPTABLE_DISTRIBUTION/1
get_specific_column(_,[],Acc,Acc).
get_specific_column(N,[H|T],Acc,Result):- get_specific_column_helper(N,1, H,X), insert_last(X,Acc,Acc1), get_specific_column(N,T,Acc1,Result).

get_specific_column_helper(N,Count, [H|_],H):- Count==N.
get_specific_column_helper(N,Count, [_|T],R):- Count<N, New_Count is Count+1, get_specific_column_helper(N,New_Count, T,R).

acceptable_distribution(G):- acceptable_distribution_helper(G, G,1).

acceptable_distribution_helper(_, [],_).
acceptable_distribution_helper(G, [H|T],Count):- get_specific_column(Count,G,[],Column), H\=Column, New_count is Count+1,acceptable_distribution_helper(G, T,New_count).

%PART 7: ROW_COL_MATCH/1
row_col_match(M):- row_col_match_helper(M,M,[],R), length1(M,Size),num_gen(1,Size,List), acceptable_permutation(List,R).

row_col_match_helper(_,[],Acc,Acc).
row_col_match_helper(M,[H|T],Acc,Result):- get_column_index(1,H, M,Index), insert_last(Index,Acc,New_Acc), row_col_match_helper(M,T,New_Acc,Result).

get_column_index(Count,Row, Grid,Count):- get_specific_column(Count,Grid,[],Column), Column=Row.
get_column_index(Count,Row, Grid,R):- get_specific_column(Count,Grid,[],Column), Column\=Row, New_Count is Count+1, get_column_index(New_Count,Row, Grid,R).

%PART 8: TRANS/2
trans(M,M1):- length1(M,Length), trans_helper(M,1,Length,[],M1).
trans_helper(_,Count, Length,Acc,Acc):- Count>Length.
trans_helper(M,Count,Length,Acc,M1):- Count=<Length, get_specific_column(Count,M,[],Result),insert_last(Result,Acc, New_Acc),New_Count is Count + 1, trans_helper(M,New_Count,Length,New_Acc,M1).

%PART 9: DISTINCT_ROWS/1
distinct_rows([]).
distinct_rows([H|T]):- \+repeated_row(H,T),distinct_rows(T).

repeated_row(H,[H1|_]):- H=H1.
repeated_row(H,[H1|T1]):- H\=H1, repeated_row(H,T1).


%PART 10: DISTINCT_COLUMNS/1
distinct_columns(M):- trans(M,M1), distinct_rows(M1).

%PART 11: HELSINKI PUZZLE
helsinki(N,G):- grid_gen(N,G),check_num_grid(G), acceptable_distribution(G), row_col_match(G), distinct_rows(G), distinct_columns(G).