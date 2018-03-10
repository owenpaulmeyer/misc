Here are two sample cases with the output following.

sample1:

int main() {
	struct s1 {
		int eat;
		float rat;}
	struct s2 {
		struct s1 yert;
		int rat,eat;
		float boat;}

	int orp,port;
	struct s1 bat;
	struct s1 bug, bite;

	bug.eat = 5;
	bug.rat = 2.0;
	bite = bug;
}

sample2:

int main() {
	string one,two,three;

	one = \"rat\";
	two = \"cheese\";
	three = one<++<\"eats\"<++<two;
	put(three<++<\"curd\");
}

output for sample1:

Program:
StructDefs: {s1[ <Int: eat><Float: rat> ]s2[ <Struct s1: yert><Int: rat><Int: eat><Float: boat> ]}
Declarations: {<Int: orp><Int: port><Struct s1: bat><Struct s1: bug><Struct s1: bite>}
Statements:
  Assignment:
    Target:
      Struct: bug
        Variable: eat
    Source:
      IntValue:  5
  Assignment:
    Target:
      Struct: bug
        Variable: rat
    Source:
      FloatValue:  2.0
  Assignment:
    Target:
      Variable: bite
    Source:
      Variable: bug


output for sample2:

Program:
StructDefs: {}
Declarations: {<String: one><String: two><String: three>}
Statements:
  Assignment:
    Target:
      Variable: one
    Source:
      StringValue: "rat"
  Assignment:
    Target:
      Variable: two
    Source:
      StringValue: "cheese"
  Assignment:
    Target:
      Variable: three
    Source:
      Binary Expression: (<++<) 
        Variable: one
        Binary Expression: (<++<) 
          StringValue: "eats"
          Variable: two
  Put:
    Binary Expression: (<++<) 
      Variable: three
      StringValue: "curd"

