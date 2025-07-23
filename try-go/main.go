package main

type AInter interface {
	Greet() string
}
type AStruct struct {
	name string
}

type BStruct struct {
}

type Child struct {
}

func (astruct *AStruct) Greet() string {
	return astruct.name
}
func NewAStruct() AInter {
	return new(AStruct)
}

func main() {
	var ainter AInter
	ainter = &AStruct{}
}
