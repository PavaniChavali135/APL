

% ============================================================================
% BASIC FACTS: Gender Information
% ============================================================================

male(john).
male(david).
male(michael).
male(robert).
male(james).
male(william).
male(thomas).
male(daniel).

female(mary).
female(susan).
female(elizabeth).
female(jennifer).
female(linda).
female(patricia).
female(sarah).
female(emily).

% ============================================================================
% BASIC FACTS: Parent Relationships
% ============================================================================
% Format: parent(Parent, Child)

% Generation 1 -> Generation 2
parent(john, david).
parent(john, susan).
parent(mary, david).
parent(mary, susan).

parent(robert, elizabeth).
parent(robert, michael).
parent(jennifer, elizabeth).
parent(jennifer, michael).

% Generation 2 -> Generation 3
parent(david, james).
parent(david, linda).
parent(susan, william).
parent(susan, patricia).

parent(elizabeth, thomas).
parent(elizabeth, sarah).
parent(michael, daniel).
parent(michael, emily).

% ============================================================================
% DERIVED RELATIONSHIPS: Basic Family Rules
% ============================================================================

% Father rule: X is the father of Y if X is parent of Y and X is male
father(X, Y) :- parent(X, Y), male(X).

% Mother rule: X is the mother of Y if X is parent of Y and X is female
mother(X, Y) :- parent(X, Y), female(X).

% Child rule: X is a child of Y if Y is parent of X
child(X, Y) :- parent(Y, X).

% Son rule: X is a son of Y if X is a child of Y and X is male
son(X, Y) :- child(X, Y), male(X).

% Daughter rule: X is a daughter of Y if X is a child of Y and X is female
daughter(X, Y) :- child(X, Y), female(X).

% ============================================================================
% DERIVED RELATIONSHIPS: Grandparent (Using Recursion)
% ============================================================================

% Grandparent rule: X is grandparent of Y if X is parent of Z and Z is parent of Y
grandparent(X, Y) :- parent(X, Z), parent(Z, Y).

% Grandfather rule: X is grandfather of Y if X is grandparent and male
grandfather(X, Y) :- grandparent(X, Y), male(X).

% Grandmother rule: X is grandmother of Y if X is grandparent and female
grandmother(X, Y) :- grandparent(X, Y), female(X).

% Grandchild rule: X is grandchild of Y if Y is grandparent of X
grandchild(X, Y) :- grandparent(Y, X).

% ============================================================================
% DERIVED RELATIONSHIPS: Sibling
% ============================================================================

% Sibling rule: X and Y are siblings if they share the same parent
% and they are different people
sibling(X, Y) :- 
    parent(Z, X), 
    parent(Z, Y), 
    X \= Y.

% Brother rule: X is brother of Y if X is sibling of Y and X is male
brother(X, Y) :- sibling(X, Y), male(X).

% Sister rule: X is sister of Y if X is sibling of Y and X is female
sister(X, Y) :- sibling(X, Y), female(X).

% ============================================================================
% DERIVED RELATIONSHIPS: Cousin
% ============================================================================

% Cousin rule: X and Y are cousins if their parents are siblings
cousin(X, Y) :- 
    parent(ParentX, X), 
    parent(ParentY, Y), 
    sibling(ParentX, ParentY).

% ============================================================================
% DERIVED RELATIONSHIPS: Uncle and Aunt
% ============================================================================

% Uncle rule: X is uncle of Y if X is male sibling of Y's parent
uncle(X, Y) :- 
    parent(Z, Y), 
    brother(X, Z).

% Aunt rule: X is aunt of Y if X is female sibling of Y's parent
aunt(X, Y) :- 
    parent(Z, Y), 
    sister(X, Z).

% ============================================================================
% RECURSIVE RELATIONSHIPS: Ancestor and Descendant
% ============================================================================

% Ancestor rule (recursive): X is ancestor of Y if:
% Base case: X is parent of Y
% Recursive case: X is parent of Z and Z is ancestor of Y
ancestor(X, Y) :- parent(X, Y).
ancestor(X, Y) :- parent(X, Z), ancestor(Z, Y).

% Descendant rule: X is descendant of Y if Y is ancestor of X
descendant(X, Y) :- ancestor(Y, X).

% ============================================================================
% UTILITY QUERIES: Helper predicates
% ============================================================================

% Get all children of a person
children(Parent, Children) :- 
    findall(Child, parent(Parent, Child), Children).

% Get all siblings of a person
siblings(Person, Siblings) :- 
    findall(Sibling, sibling(Person, Sibling), Siblings).

% Get all cousins of a person
cousins(Person, Cousins) :- 
    findall(Cousin, cousin(Person, Cousin), Cousins).

% Get all descendants of a person
descendants(Person, Descendants) :- 
    findall(Descendant, descendant(Descendant, Person), Descendants).

% Get all ancestors of a person
ancestors(Person, Ancestors) :- 
    findall(Ancestor, ancestor(Ancestor, Person), Ancestors).

% ============================================================================
% SAMPLE QUERIES AND DEMONSTRATIONS
% ============================================================================

% Demo query runner - executes common queries for demonstration
demo_queries :-
    write('========================================'), nl,
    write('FAMILY TREE DEMO QUERIES'), nl,
    write('========================================'), nl, nl,
    
    write('1. Who are John\'s children?'), nl,
    write('   Query: children(john, X)'), nl,
    children(john, JohnChildren),
    write('   Result: '), write(JohnChildren), nl, nl,
    
    write('2. Is John the father of David?'), nl,
    write('   Query: father(john, david)'), nl,
    (father(john, david) -> write('   Result: true') ; write('   Result: false')), nl, nl,
    
    write('3. Who are the grandchildren of Mary?'), nl,
    write('   Query: findall(X, grandchild(X, mary), GC)'), nl,
    findall(X, grandchild(X, mary), MaryGrandchildren),
    write('   Result: '), write(MaryGrandchildren), nl, nl,
    
    write('4. Are David and Susan siblings?'), nl,
    write('   Query: sibling(david, susan)'), nl,
    (sibling(david, susan) -> write('   Result: true') ; write('   Result: false')), nl, nl,
    
    write('5. Are James and William cousins?'), nl,
    write('   Query: cousin(james, william)'), nl,
    (cousin(james, william) -> write('   Result: true') ; write('   Result: false')), nl, nl,
    
    write('6. Who are all descendants of John?'), nl,
    write('   Query: descendants(john, X)'), nl,
    descendants(john, JohnDescendants),
    write('   Result: '), write(JohnDescendants), nl, nl,
    
    write('7. Who are the ancestors of James?'), nl,
    write('   Query: ancestors(james, X)'), nl,
    ancestors(james, JamesAncestors),
    write('   Result: '), write(JamesAncestors), nl, nl,
    
    write('========================================'), nl,
    write('DEMO COMPLETED'), nl,
    write('========================================'), nl.

% Individual sample queries (can be called separately)
sample_query(1) :- write('Query: Who are John\'s children?'), nl,
                   children(john, X), write(X), nl.
sample_query(2) :- write('Query: Is John the father of David?'), nl,
                   father(john, david), write('true'), nl.
sample_query(3) :- write('Query: Who are siblings of David?'), nl,
                   siblings(david, X), write(X), nl.
sample_query(4) :- write('Query: Are James and William cousins?'), nl,
                   cousin(james, william), write('true'), nl.
sample_query(5) :- write('Query: All descendants of John?'), nl,
                   descendants(john, X), write(X), nl.

% ============================================================================
% AUTOMATED TEST SUITE
% ============================================================================

% Main test runner - executes all test categories
run_all_tests :-
    write('========================================'), nl,
    write('FAMILY TREE PROGRAM - TEST SUITE'), nl,
    write('========================================'), nl, nl,
    test_basic_relationships,
    test_grandparent_relationships,
    test_sibling_relationships,
    test_cousin_relationships,
    test_recursive_relationships,
    test_complex_queries,
    write('========================================'), nl,
    write('ALL TESTS COMPLETED SUCCESSFULLY'), nl,
    write('========================================'), nl.

% Test 1: Basic Parent-Child Relationships
test_basic_relationships :-
    write('TEST 1: Basic Parent-Child Relationships'), nl,
    write('------------------------------------------'), nl,
    
    % Test 1.1: Children query
    write('  [1.1] Testing: children(john, Children)'), nl,
    children(john, Children1),
    write('        Result: '), write(Children1), nl,
    (Children1 = [david, susan] -> 
        write('        [PASS]'), nl ; 
        (write('        [FAIL]'), nl, fail)),
    
    % Test 1.2: Father query
    write('  [1.2] Testing: father(john, david)'), nl,
    (father(john, david) -> 
        write('        [PASS]'), nl ; 
        (write('        [FAIL]'), nl, fail)),
    
    % Test 1.3: Mother query
    write('  [1.3] Testing: mother(mary, susan)'), nl,
    (mother(mary, susan) -> 
        write('        [PASS]'), nl ; 
        (write('        [FAIL]'), nl, fail)),
    
    % Test 1.4: Son query
    write('  [1.4] Testing: son(david, john)'), nl,
    (son(david, john) -> 
        write('        [PASS]'), nl ; 
        (write('        [FAIL]'), nl, fail)),
    
    % Test 1.5: Daughter query
    write('  [1.5] Testing: daughter(susan, mary)'), nl,
    (daughter(susan, mary) -> 
        write('        [PASS]'), nl ; 
        (write('        [FAIL]'), nl, fail)),
    nl.

% Test 2: Grandparent Relationships
test_grandparent_relationships :-
    write('TEST 2: Grandparent Relationships'), nl,
    write('------------------------------------------'), nl,
    
    % Test 2.1: Grandfather query
    write('  [2.1] Testing: grandfather(john, james)'), nl,
    (grandfather(john, james) -> 
        write('        [PASS]'), nl ; 
        (write('        [FAIL]'), nl, fail)),
    
    % Test 2.2: Grandmother query
    write('  [2.2] Testing: grandmother(mary, linda)'), nl,
    (grandmother(mary, linda) -> 
        write('        [PASS]'), nl ; 
        (write('        [FAIL]'), nl, fail)),
    
    % Test 2.3: All grandchildren query
    write('  [2.3] Testing: findall grandchildren of john'), nl,
    findall(X, grandchild(X, john), GC),
    write('        Result: '), write(GC), nl,
    (GC = [james, linda, william, patricia] -> 
        write('        [PASS]'), nl ; 
        (write('        [FAIL]'), nl, fail)),
    
    % Test 2.4: Grandparent query
    write('  [2.4] Testing: grandparent(mary, william)'), nl,
    (grandparent(mary, william) -> 
        write('        [PASS]'), nl ; 
        (write('        [FAIL]'), nl, fail)),
    nl.

% Test 3: Sibling Relationships
test_sibling_relationships :-
    write('TEST 3: Sibling Relationships'), nl,
    write('------------------------------------------'), nl,
    
    % Test 3.1: Basic sibling query
    write('  [3.1] Testing: sibling(david, susan)'), nl,
    (sibling(david, susan) -> 
        write('        [PASS]'), nl ; 
        (write('        [FAIL]'), nl, fail)),
    
    % Test 3.2: Sibling symmetry
    write('  [3.2] Testing: sibling symmetry'), nl,
    (sibling(susan, david) -> 
        write('        [PASS]'), nl ; 
        (write('        [FAIL]'), nl, fail)),
    
    % Test 3.3: Not own sibling
    write('  [3.3] Testing: NOT sibling(david, david)'), nl,
    (\+ sibling(david, david) -> 
        write('        [PASS]'), nl ; 
        (write('        [FAIL]'), nl, fail)),
    
    % Test 3.4: Brother query
    write('  [3.4] Testing: brother(david, susan)'), nl,
    (brother(david, susan) -> 
        write('        [PASS]'), nl ; 
        (write('        [FAIL]'), nl, fail)),
    
    % Test 3.5: Sister query
    write('  [3.5] Testing: sister(susan, david)'), nl,
    (sister(susan, david) -> 
        write('        [PASS]'), nl ; 
        (write('        [FAIL]'), nl, fail)),
    
    % Test 3.6: All siblings query
    write('  [3.6] Testing: siblings(james, X)'), nl,
    siblings(james, JS),
    (JS = [linda] -> 
        write('        [PASS]'), nl ; 
        (write('        [FAIL]'), nl, fail)),
    nl.

% Test 4: Cousin Relationships
test_cousin_relationships :-
    write('TEST 4: Cousin Relationships'), nl,
    write('------------------------------------------'), nl,
    
    % Test 4.1: Basic cousin query
    write('  [4.1] Testing: cousin(james, william)'), nl,
    (cousin(james, william) -> 
        write('        [PASS]'), nl ; 
        (write('        [FAIL]'), nl, fail)),
    
    % Test 4.2: Cousin symmetry
    write('  [4.2] Testing: cousin symmetry'), nl,
    (cousin(william, james) -> 
        write('        [PASS]'), nl ; 
        (write('        [FAIL]'), nl, fail)),
    
    % Test 4.3: All cousins query
    write('  [4.3] Testing: cousins(thomas, X)'), nl,
    cousins(thomas, TC),
    (TC = [daniel, emily] -> 
        write('        [PASS]'), nl ; 
        (write('        [FAIL]'), nl, fail)),
    
    % Test 4.4: Not own cousin
    write('  [4.4] Testing: NOT cousin(james, linda)'), nl,
    (\+ cousin(james, linda) -> 
        write('        [PASS]'), nl ; 
        (write('        [FAIL]'), nl, fail)),
    nl.

% Test 5: Recursive Ancestor-Descendant Relationships
test_recursive_relationships :-
    write('TEST 5: Recursive Relationships'), nl,
    write('------------------------------------------'), nl,
    
    % Test 5.1: Direct ancestor
    write('  [5.1] Testing: ancestor(john, david)'), nl,
    (ancestor(john, david) -> 
        write('        [PASS]'), nl ; 
        (write('        [FAIL]'), nl, fail)),
    
    % Test 5.2: Indirect ancestor (2 levels)
    write('  [5.2] Testing: ancestor(john, james)'), nl,
    (ancestor(john, james) -> 
        write('        [PASS]'), nl ; 
        (write('        [FAIL]'), nl, fail)),
    
    % Test 5.3: All ancestors query
    write('  [5.3] Testing: ancestors(james, X)'), nl,
    ancestors(james, JA),
    write('        Result: '), write(JA), nl,
    (JA = [david, john, mary] -> 
        write('        [PASS]'), nl ; 
        (write('        [FAIL]'), nl, fail)),
    
    % Test 5.4: Descendant query
    write('  [5.4] Testing: descendant(james, john)'), nl,
    (descendant(james, john) -> 
        write('        [PASS]'), nl ; 
        (write('        [FAIL]'), nl, fail)),
    
    % Test 5.5: All descendants query
    write('  [5.5] Testing: descendants(john, X)'), nl,
    descendants(john, JD),
    write('        Result: '), write(JD), nl,
    (JD = [david, susan, james, linda, william, patricia] -> 
        write('        [PASS]'), nl ; 
        (write('        [FAIL]'), nl, fail)),
    nl.

% Test 6: Complex Queries
test_complex_queries :-
    write('TEST 6: Complex Queries'), nl,
    write('------------------------------------------'), nl,
    
    % Test 6.1: Male descendants
    write('  [6.1] Testing: Find all male descendants of john'), nl,
    findall(X, (descendant(X, john), male(X)), MD),
    write('        Result: '), write(MD), nl,
    (MD = [david, james, william] -> 
        write('        [PASS]'), nl ; 
        (write('        [FAIL]'), nl, fail)),
    
    % Test 6.2: Female grandchildren
    write('  [6.2] Testing: Find female grandchildren of mary'), nl,
    findall(X, (grandchild(X, mary), female(X)), FG),
    write('        Result: '), write(FG), nl,
    (FG = [linda, patricia] -> 
        write('        [PASS]'), nl ; 
        (write('        [FAIL]'), nl, fail)),
    
    % Test 6.3: Count all people
    write('  [6.3] Testing: Count total people in family tree'), nl,
    findall(X, (male(X) ; female(X)), AllPeople),
    length(AllPeople, Count),
    write('        Count: '), write(Count), nl,
    (Count = 16 -> 
        write('        [PASS]'), nl ; 
        (write('        [FAIL]'), nl, fail)),
    
    % Test 6.4: Uncle/Aunt relationships
    write('  [6.4] Testing: aunt(susan, james)'), nl,
    (aunt(susan, james) -> 
        write('        [PASS]'), nl ; 
        (write('        [FAIL]'), nl, fail)),
    
    % Test 6.5: Uncle relationship
    write('  [6.5] Testing: uncle(david, william)'), nl,
    (uncle(david, william) -> 
        write('        [PASS]'), nl ; 
        (write('        [FAIL]'), nl, fail)),
    nl.

% ============================================================================
% UTILITY PREDICATES FOR INFORMATION DISPLAY
% ============================================================================

% Display all family members
show_all_people :-
    write('ALL FAMILY MEMBERS BY GENERATION'), nl,
    write('------------------------------------------'), nl,
    write('Generation 1 (Grandparents):'), nl,
    write('  Males: john, robert'), nl,
    write('  Females: mary, jennifer'), nl, nl,
    write('Generation 2 (Parents):'), nl,
    write('  Males: david, michael'), nl,
    write('  Females: susan, elizabeth'), nl, nl,
    write('Generation 3 (Children):'), nl,
    write('  Males: james, william, thomas, daniel'), nl,
    write('  Females: linda, patricia, sarah, emily'), nl.

% Display visual family tree
show_family_tree :-
    nl,
    write('FAMILY TREE STRUCTURE'), nl,
    write('========================================'), nl,
    write('Generation 1:'), nl,
    write('  John (M) == Mary (F)         Robert (M) == Jennifer (F)'), nl,
    write('      |                              |'), nl,
    write('      +----------+----------+         +----------+----------+'), nl,
    write('      |          |          |         |          |          |'), nl,
    write('Generation 2:'), nl,
    write('   David(M)  Susan(F)           Elizabeth(F) Michael(M)'), nl,
    write('      |          |                    |          |'), nl,
    write('      +----+     +----+               +----+     +----+'), nl,
    write('      |    |     |    |               |    |     |    |'), nl,
    write('Generation 3:'), nl,
    write('  James Linda William Patricia   Thomas Sarah Daniel Emily'), nl,
    write('   (M)   (F)    (M)     (F)        (M)   (F)   (M)   (F)'), nl,
    write('========================================'), nl.

% Display family tree statistics
show_statistics :-
    write('========================================'), nl,
    write('FAMILY TREE STATISTICS'), nl,
    write('========================================'), nl,
    findall(M, male(M), Males),
    length(Males, MaleCount),
    write('Total Males: '), write(MaleCount), nl,
    findall(F, female(F), Females),
    length(Females, FemaleCount),
    write('Total Females: '), write(FemaleCount), nl,
    findall([P,C], parent(P,C), ParentPairs),
    length(ParentPairs, ParentCount),
    write('Parent-Child Pairs: '), write(ParentCount), nl,
    Total is MaleCount + FemaleCount,
    write('Total People: '), write(Total), nl,
    write('========================================'), nl.

% Quick help command
help :-
    write('========================================'), nl,
    write('FAMILY TREE PROGRAM - HELP'), nl,
    write('========================================'), nl,
    write('Main Commands:'), nl,
    write('  run_all_tests.      - Run automated test suite'), nl,
    write('  demo_queries.       - Run sample query demonstrations'), nl,
    write('  show_statistics.    - Display family tree statistics'), nl,
    write('  show_all_people.    - Display all family members'), nl,
    write('  help.               - Show this help message'), nl, nl,
    write('Sample Queries:'), nl,
    write('  children(john, X).           - Get John\'s children'), nl,
    write('  father(john, david).         - Is John father of David?'), nl,
    write('  siblings(david, X).          - Get David\'s siblings'), nl,
    write('  cousin(james, william).      - Are they cousins?'), nl,
    write('  descendants(john, X).        - Get all descendants'), nl,
    write('  ancestor(john, james).       - Is John ancestor of James?'), nl,
    write('========================================'), nl.

% ============================================================================
% AUTO-EXECUTION ON LOAD
% ============================================================================

% Automatically execute everything when file is loaded
:- initialization(run_everything).

% Main auto-execution predicate
run_everything :-
    nl,
    write('========================================'), nl,
    write('FAMILY TREE PROGRAM - AUTO-EXECUTION'), nl,
    write('========================================'), nl, nl,
    
    % 1. Display family tree structure
    write('STEP 1: DISPLAYING FAMILY TREE'), nl,
    write('========================================'), nl,
    show_family_tree,
    nl,
    show_all_people,
    nl,
    show_statistics,
    nl, nl,
    
    % 2. Run demo queries
    write('STEP 2: RUNNING DEMO QUERIES'), nl,
    write('========================================'), nl,
    demo_queries,
    nl, nl,
    
    % 3. Run all tests
    write('STEP 3: RUNNING AUTOMATED TEST SUITE'), nl,
    write('========================================'), nl,
    run_all_tests,
    nl, nl,
    
    % 4. Final summary
    write('========================================'), nl,
    write('AUTO-EXECUTION COMPLETED SUCCESSFULLY'), nl,
    write('========================================'), nl,
    write('All queries and tests executed automatically!'), nl,
    write('You can now run individual queries manually.'), nl,
    write('Type "help." for available commands.'), nl,
    write('========================================'), nl, nl.
