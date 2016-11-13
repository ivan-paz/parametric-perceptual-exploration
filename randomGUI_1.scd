//--------------------------------------------------------------
//    A GUI interface for perceptual parametric exploration           //    of a simple generative system stored int an Ndef
//                         Ivan Paz
//--------------------------------------------------------------
(
var window, system, system1;
var boot, location;
var data = [ ];
var initialize, play, random, random1, random2;
var box1,box2,box3,box4,box5,box6,a=0,b=400,c=0,d=400,e=0,f=10;
var class1, class2, class3, class4;
var delete, deleteInstance, selectInstance, number=nil;
var postdata, ruleExtraction, showrules, saveData, loadData;
var tdef, playclass1, playclass2, playclass3;
var try1, try2, try3;
var csvdata, csvrules;

// In OSX systems import files from the same directory
// loadRelative("rule_extraction_function.scd");

// In linux systems change the location of rule_extraction_function.scd
location = "/home/ivan/documents/ia/par_by_par_compression_algorithm/parametric-perceptual-exploration/";
(location ++ "rule_extraction_function.scd").load;
(location ++ "rule_processing_functions.scd").load;


window = Window.new("Exploring parameters Blip",Rect(650,320,500,400),resizable:true).front;
//------------------ load the systems    -------------------------
system = Ndef(\x,{
	arg freq, numharm, amp;
	var sig;
	sig = Blip.ar(freq, numharm)!2;
	sig = FreeVerb.ar(sig, 0.23, 0.5, 0.5, 1) * amp;
});
//---------------------------------------------------------------
boot = Button.new(window, Rect(5, 5, 100, 40));
boot.states = [['boot system'],['quit']];
boot.action = {arg val; if(val.value == 1){s.boot;
	'Exploring parameters interface!'.postln}{s.quit;'server off'.postln}
};

initialize = Button.new(window,Rect(5,50, 100, 55));
initialize.states = [["Initialize data"]];
initialize.action ={
	data = []; //Array to store classified parameter combinations
'data set to -> [ ] '.postln };

play = Button.new(window,Rect(5,110,100,55));
play.states = [["Play"],["Stop"]];
play.action = {arg val; if(val.value==1){system.play;'playing'.postln}{system.stop;'stop'.postln}};


random = Button.new(window,Rect(5,170,53,55));
random.states = [["Ran 1"]];
random.action = {var par; par = rrand(a,b);
system.set(\freq, par).getKeysValues.postln};
random1 = Button.new(window,Rect(60,170,53,55));
random1.states = [["Ran 2"]];
random1.action = {var par1; par1 = rrand(c,d);
system.set(\numharm, par1).getKeysValues.postln};
random2 = Button.new(window,Rect(115,170,53,55));
random2.states = [["Ran 3"]];
random2.action = {var par2; par2 = rrand(e,f)/f;
system.set(\amp, par2).getKeysValues.postln};

//-----
box1 = NumberBox(window, Rect(5, 230, 50, 30)).value_(0.0);
box1.action = {|val| a = val.value.postln};
box2 = NumberBox(window, Rect(5, 265, 50, 30)).value_(0.0);
box2.action = {|val| b = val.value.postln};
box3 = NumberBox(window, Rect(60, 230,50, 30)).value_(0.0);
box3.action = {|val| c = val.value.postln};
box4 = NumberBox(window, Rect(60, 265,50, 30)).value_(0.0);
box4.action = {|val| d = val.value.postln};
box5 = NumberBox(window, Rect(115,230,50, 30)).value_(0.0);
box5.action = {|val| e = val.value.postln};
box6 = NumberBox(window, Rect(115,265, 50,30)).value_(0.0);
box6.action = {|val| f = val.value.postln};

//   classification ------------------
// 1
class1 = Button.new(window,Rect(5,310,53,55));
class1.states =[['Class 1']];
class1.action = {var values, instance = [];
	values = system.getKeysValues.post; '  Class 1'.postln;
	values.do{|x| instance = instance.add(x[1])};
	instance = instance.add(1);
	if(data.indexOfEqual(instance).isNil){data = data.add(instance)}{
	'combination already in data'.postln}
};
// 2
class2 = Button.new(window,Rect(60,310,53,55));
class2.states =[['Class 2']];
class2.action = {var values, instance = [];
	values = system.getKeysValues.post; '  Class 2'.postln;
	values.do{|x| instance = instance.add(x[1])};
	instance = instance.add(2);
	if(data.indexOfEqual(instance).isNil){data = data.add(instance)}{
		'combination already in data'.postln}
};
// 3
class3 = Button.new(window,Rect(115,310,53,55));
class3.states =[['Class 3']];
class3.action = {var values, instance = [];
	values = system.getKeysValues.post; '  Class 3'.postln;
	values.do{|x| instance = instance.add(x[1])};
	instance = instance.add(3);
	if(data.indexOfEqual(instance).isNil){data = data.add(instance)}{
		'combination already in data'.postln}
};
delete = Button.new(window, Rect(5, 370, 163, 20));
delete.states = [['Remove last instance']];
delete.action = {var size = data.size; data = data[0..size-2];'last instance deleted!'.postln};
//-------------------------------------------------------------------
postdata = Button.new(window,Rect(195,50,100,55));
postdata.states = [['show data']];
postdata.action = {'Data : '.postln;data.do{|x, i| i.post;' '.post; x.postln}};

ruleExtraction = Button.new(window,Rect(195,110,100,55));
ruleExtraction.states = [['Rule Extraction']];
ruleExtraction.action = {
(~intervals_and_distances = [
	[
		[ [0,inf],  10 ]
	],
	[
		[ [0,inf],  200 ]
	],
	[
		[ [0, inf],  1 ]
	]
]);
//  Extract rules
~rules = ~subsetsCompression.value(data,~intervals_and_distances);
//--------------------------------------
~classes = ~count_classes.value(data);
~unique = ~unique_rules.value(~rules);
//~non_redundant_rules = ~redundant_rules.value(~unique);check nil
~split = ~splitRules_uncompleted.value(~unique);
};
showrules = Button.new(window,Rect(195,170,100,55));
showrules.states = [['bag of rules']];
showrules.action = {'-----------------------------'.postln;'Bag of rules :'.postln; ~split.do{|x,i|
	("Rules of Class " ++ (i+1).asString).postln; x.do{|y,j|j.post;'  '.post;y.postln}}};

saveData = Button.new(window, Rect(195,230, 100, 55));
saveData.states = [['save data']];
saveData.action = {
	data.writeArchive(location ++ "data");
	'data saved into a file'.postln
};
loadData = Button.new(window, Rect(195,290, 100, 55));
loadData.states = [['load data']];
loadData.action = {
	data = Object.readArchive(location ++ "data");
	'data loaded !'.postln
};
deleteInstance = Button.new(window, Rect(195, 350, 50, 40));
deleteInstance.states = [['delete']];
deleteInstance.action = {
	if( (number.class!=nil)&&(data!=[]) ){

		var tmp = [];
		data[number.asInteger] = nil;
		data.do{|x| if(x.notNil){tmp = tmp.add(x)}};
		data = tmp;
		'Instance deleted!  New data:'.postln;
		data.do{|x, i| i.post;' '.post;x.postln}

	}{'Error: empty data or missing index'.postln
}};
selectInstance = NumberBox.new(window, Rect(250, 350, 50, 40));
selectInstance.action = { |val|
	if((val.value).notNil){number = val.value.asInteger.postln}{
	'Error: please insert an Index'.postln}};
	
//----------------------------------------------------------------
//-----------------           play        ------------------------
//----------------------------------------------------------------


//   -----------------    Rule selection function
~selectRule = { |splitRules, class|
	var ruleTemp = [], rule = [];
	if( (splitRules[class]!=[]) && (splitRules[class].notNil) ){
		ruleTemp = splitRules[class].choose;
		ruleTemp.do{ |x|
			var value;
			if(x.class == Array){value = x.choose; rule = rule.add(value)}{rule = rule.add(x)};
		};
	}{'there are no rules for this class'.postln};
	rule
};
~generate = { arg rule;
	var instance;
	rule.collect({arg entrance;
		var value;
		if(entrance.class==Array){value = rrand(entrance.minItem,entrance.maxItem)}{value = entrance};
		instance = instance.add(value);
	});
	instance
};
//   ----------------------------------
~class = 0;
Tdef(\sending,{ arg values, rule;
	inf.do{
		10.do{
			rule = ~selectRule.value(~split,~class);
			rule.postln;
			Ndef(\x).set(\freq, rule[0], \numharm, rule[1],
			\amp, rule[2]);
			[ 7, 3, 5].choose.wait;
		};
		5.do{
			rule = ~selectRule.value(~split,~class);
			rule.postln;
			Ndef(\x).set(\freq, rule[0], \numharm, rule[1],
			\amp, rule[2]);
			[1, 0.5, 0.25].choose.wait;
		}
	}
});
//---------------------------------------------------------
tdef = Button.new(window,Rect(350,50,100,55));
tdef.states = [['Sequence'],['Stop']];
tdef.action = {|val| if(val.value == 1){Tdef(\sending).play; 'playing'.postln}{Tdef(\sending).stop; 'stop'.postln }};

csvdata = Button.new(window, Rect(350,110,55,55));
csvdata.states = [['data csv']];
csvdata.action = {
	f = File(location ++ "data.csv","w");
	data.do{arg x, i;
		        f.write(i + "," + x + "\n");
			};
			f.close
};
csvrules = Button.new(window, Rect(410,110,55,55));
csvrules.states = [['rules csv']];
csvrules.action = {
	f = File(location ++ "rules.csv","w");
	~split.do{arg x;
		x.do{arg y,j;
		f.write(j + "," + y + "\n")
	}};
	f.close
};

playclass1 = Button.new(window,Rect(320,230,53,55));
playclass1.states =[['Play-1']];
playclass1.action = {var rule;
	~class = 0; 'class 1 selected'.postln;
	rule = ~selectRule.value(~split,~class).postln;
	system.set(\freq,rule[0],\numharm,rule[1],\amp,rule[2]);
};
playclass2 = Button.new(window,Rect(380,230,53,55));
playclass2.states =[['Play-2']];
playclass2.action = {var rule;
	~class = 1; 'class 2 selected'.postln;
	rule = ~selectRule.value(~split,~class).postln;
	system.set(\freq,rule[0],\numharm,rule[1],\amp,rule[2])
};
playclass3 = Button.new(window,Rect(440,230,53,55));
playclass3.states =[['Play-3']];
playclass3.action = {var rule;
	~class = 2; 'class 3 selected'.postln;
	rule = ~selectRule.value(~split,~class).postln;
	system.set(\freq, rule[0], \numharm, rule[1], \amp, rule[2])
};

//////////////////////////////////////////////////////////////
//          generate function create a new instance
//        with random values taken from the intervals
//               created during the compression
//////////////////////////////////////////////////////////////
try1 = Button.new(window, Rect(320, 300, 53, 55));
try1.states = [['Try-1']];
try1.action = {var rule, newInstance;
	rule = ~split[0].choose;
	newInstance = ~generate.value(rule);
	system.set(\freq, newInstance[0], \numharm, newInstance[1], \amp, newInstance[2]);
	newInstance.postln
};
try2 = Button.new(window, Rect(380, 300, 53, 55));
try2.states = [['Try-2']];
try2.action = {var rule, newInstance;
	rule = ~split[1].choose;
	newInstance = ~generate.value(rule);
	system.set(\freq, newInstance[0], \numharm, newInstance[1], \amp, newInstance[2]);
	newInstance.postln
};
try3 = Button.new(window, Rect(440, 300, 53, 55));
try3.states = [['Try-3']];
try3.action = {var rule, newInstance;
	rule = ~split[2].choose;
	newInstance = ~generate.value(rule);
	system.set(\freq, newInstance[0], \numharm, newInstance[1], \amp, newInstance[2]);
	newInstance.postln
};

)




