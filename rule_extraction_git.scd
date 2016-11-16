//.................................................................
//                         rule extraction                      ...
//                            algorithm                         ...
//                           git version                        ...
//.................................................................
(
~count_classes = {
	arg z;
	var size, classes;
	if(z.notNil){
		if(z[0].notNil){
		size=z[0].size;
		classes = Array.fill(size);
		z.do{arg instance;
			instance.do{arg x,i;
				classes[i] = classes[i].add(x);
			}
		};
		classes.do{arg x,i;
			classes[i]= x.asSet.size;
		}
	}{"Error: empty data".postln}}{'Error:data is nil'.postln}
};
//(
//~parameter_intervals_and_distances = [ [[0,inf],20] ];
//~array = [0.1,1,2,10,20,30];
//~indexesOfParameterValues = [1,2,4,6,8,11]
//)
//(~create_subsets = { arg parameter_intervals_and_distances,array;
//	var ta = [], sets=[], final_sets=[];
//	{array.size>1}.while{
//		var diff, distance;
//		distance = ~allowed_distance.value(parameter_intervals_and_distances,array.first);
		//'distance'.post;distance.postln;
//		ta=ta.add(array.first);
//		array=array[1..];
//		diff=abs(ta.last - array.first);
//		if(diff<distance){
//			ta=ta.add(array.first);
//			array=array[1..];
//		}{
//			sets = sets.add(ta); ta = []
//		}
//	};
//	if(ta.size>1){sets = sets.add(ta)};
//	sets.collect{arg set; if(set.size>1){final_sets =final_sets.add(set)}};
//	final_sets
//});
//TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT
~insertionSort = { |array, indexes|
	var tmp, j, tmp1;
	(array.size - 1).do{ |i|
		tmp = array[i+1];
		tmp1 = indexes[i +1];
		j = i;
		while ({(j >= 0) && {array[j] > tmp}},
		{
			array.put(j + 1, array[j]);
			indexes.put(j + 1, indexes[j]);
			j = j - 1;
		});
		array.put(j+1, tmp);
		indexes.put(j+1,tmp1);
	};
	[array, indexes]
};

(~create_subsets = { arg parameter_intervals_and_distances, array, indexesOfParameterValues;
	var ta = [], sets=[], final_sets=[];
	{array.size>0}.while{
		var diff, distance;
		array = ~insertionSort.value(array,indexesOfParameterValues)[0];
		distance = ~allowed_distance.value(parameter_intervals_and_distances,array.first);
		ta = ta.add(array.first);
		array = array[1..];
		if(array.first.notNil){
			diff = abs(ta.last - array.first);
			if(diff<distance){
				ta=ta.add(array.first);
				array=array[1..];
			}{
				sets = sets.add(ta); ta = []
			}}
		};
		if(ta.size>1){sets = sets.add(ta)};
		sets.collect{arg set; if(set.size>1){final_sets =final_sets.add(set)}};
		final_sets
	});
//TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT
(~allowed_distance={arg parameter_intervals_and_distances, value;
	var result;
	parameter_intervals_and_distances.do{arg x, i;
		var interval;
		interval = parameter_intervals_and_distances[i];
		if(interval[0][0]<value && (value <= interval[0][1])){result=interval[1]};
	};
	result
}
);
);

//~rules = ~subsetsCompression.value(~data, ~intervals_and_distances)
//(~data = [
//	[0.1, 1, 1],
//	[0.2, 1, 1],
//	[0.3, 1, 1],
//	[0.4, 1, 1],
//	[0.5, 1, 1],
//	[0.5, 3, 1]
//];
//~intervals_and_distances = [
//	[
//
//		[ [0, inf], 1]
//	
//	],
//
//	[
//
//		[ [0,inf], 5 ]
//	
//	]
//])
//
//~rules = ~subsetsCompression.value(~data,  ~intervals_and_distances);
//~rules.do{arg x, i;  i.postln; x.postln}
(
~subsetsCompression = { arg data, intervals_and_distances;
	var sets, collection, compactionOrders, size, subspacesValues;
	size = ~count_classes.value(data).size;
	sets = [];
	subspacesValues = [];
	collection = (0 .. size - 2); // last item is always classifier
	compactionOrders = (collection.size.factorial).collect {|i|
		collection.permute(i)
	};
	compactionOrders.collect { |order|
		var temporalData = data.deepCopy;
//		'Compaction Order: '.post; order.postln;
		order.collect { |colToExclude|
			var section, selection, subsets;
			var newRule;
//			'colToExclude : '.post;colToExclude.postln;
			section = (0..size-1).removing(colToExclude);
			subsets = temporalData.slice(nil, section);
			selection = temporalData.slice(nil, colToExclude);
			subsets.do { |x, i|
				var parameterValues = [ ];
				var indexesOfParameterValues = [ ];
				var count = 0;
				var row = temporalData[i];
				subsets.do { |y,  j |
					count = count + 1;
					if(x==y) {
						if(temporalData.at(j).notNil){
							parameterValues = parameterValues.add(temporalData[j][colToExclude]);
							indexesOfParameterValues = indexesOfParameterValues.add(j);
						}};
					if(count == data.size){count = 0;
//						'parameter values'.post;parameterValues.post;'indexes of parameters values'.post;indexesOfParameterValues.post;
						~parameter_intervals_and_distances = intervals_and_distances[colToExclude];
						if(parameterValues.size>1){	 //'creating rule !!!'.postln;
							~subsets = ~create_subsets.value(~parameter_intervals_and_distances, parameterValues,indexesOfParameterValues);
						// create new rule and delete the corresponding instances
						indexesOfParameterValues = ~insertionSort.value(parameterValues,indexesOfParameterValues)[1];
						temporalData = ~newRule.value(temporalData,parameterValues,indexesOfParameterValues,row,colToExclude,~subsets);
					}}
			}}
		};
		sets = sets.add(temporalData);
	};
	sets = sets.collect({ |x| x.reject(_.isNil) });
	sets
}
);


/////////    create rule and delete instances form data
//(
//~row = [1,2,1];
//~temporalData = ~data.deepCopy;
//~parameterValues =[1,2];
//~indexesOfParameterValues =[0,1];
//~colToExclude = 0;
//~subsets = [[1,2]]
//)
//~newRule.value(~temporalData,~parameterValues,~indexesOfParameterValues,~row,~colToExclude,~subsets)

(~newRule = {
	arg temporalData, parameterValues, indexesOfParameterValues, row, colToExclude, subsets;
	var newRule, deleteInstances;
	subsets.do{arg subset;
		newRule = row.deepCopy;
		newRule[colToExclude]=subset;
		temporalData = temporalData.add(newRule);
//		'temporal Data : '.post; temporalData.postln;
	};
	deleteInstances = ~deleteInstances.value(subsets,parameterValues,indexesOfParameterValues);
	deleteInstances.do{arg index;
		temporalData[index]=nil;
	};
//	'temporl data after delete instances'.post;temporalData.postln;
	temporalData
});
//~deleteInstances.value(~subsets,~parameterValues,~indexesOfParameterValues)
(
~deleteInstances = {
	arg subsets, parameterValues, indexesOfParameterValues;
	var deleteInstances = [];
	subsets.do{arg subset;
		subset.do{arg number;
			var index;
			index = parameterValues.indexOf(number);
			deleteInstances = deleteInstances.add(indexesOfParameterValues[index]);
		}
	};
	deleteInstances
}
);


//------------------------------------------------------------------
//                     clean the extracted                     .....
//                            rules                            .....
//------------------------------------------------------------------


(
~bagOfRules_uncompleted = { |rules|
	var bag = [];
	rules.do{ |x|
		x.do{ |y|
			y.do{|z|
		//	if(z.class == Array){
				if(bag.indexOfEqual(y)==nil){
					bag = bag.add(y);
					}
			//	}
			}
		}
	};
	bag
}
);
(
~splitRules_uncompleted = { |rules|
	var last, classes, array, splitedRules;
	if(rules.size != 0){
	last = ~classes.last;
	classes = (1 .. last);
	array = Array.fill2D(classes.size);
	rules.do{ |x|
		var evaluation;
		evaluation = x.last;
		classes.do{ |y, i|
			var temporal = [];
			if( evaluation == y) {
				temporal = array[y-1];
				temporal = temporal.add(x);
				array[ y - 1 ] = temporal
			};
		};
	};
	splitedRules = array;
}}
);

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//               script to eliminate the
//                    redundant rules
//         comming from different compaction orders
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//(~rules = [
//	[18,  [28, 242], 1],
//	[[10,18], 28, 1],
//	[10, [20,88], 1],
//	[10, [16,20,28,88], 1]
//])

(~redundant_rules = {
arg rules;
var indexes; var result = [];
var newIntervals, deleteIndexes = [];
var temporalRules = rules.deepCopy;
var nonRedundantRules = [];
indexes = (0 .. rules[0].size - 2);
indexes.collect{ arg colToExclude;
//var temporalRules = rules;
var section, subsets, selection;
var temporal = [];
section = (0.. indexes.size).removing(colToExclude);
subsets = temporalRules.slice(nil,section);
selection = temporalRules.slice(nil,colToExclude);
subsets.do{ arg row, i;
	var values = [], indexes = [];
	//'row : '.post; row.postln;
	values = values.add(selection[i]);indexes=indexes.add(i);
	subsets.do{ arg row1, j;
		if((row==row1) && (i!=j)){
			if(row1.notNil){
				values = values.add(selection[j]);
				indexes = indexes.add(j)};
			}};
			if(values.size>1){
//				'indexes'.post;indexes.post;values.postln;
				deleteIndexes = ~content.value(values,indexes);
//				'delete indexes : '.post;deleteIndexes.postln
			};
			deleteIndexes.collect({|index| temporalRules[index]=nil})
		}
		//deleteIndexes.collect({arg index; temporalRules[index]=nil});
	};
	temporalRules.do{|rule|
		if(rule.notNil){nonRedundantRules = nonRedundantRules.add(rule)}
	};
	nonRedundantRules
});
//~nonRedundant = ~redundant_rules.value(~rules);
//~nonRedundant
(~content = {arg values, indexes;
	var dictionaries = [];
	var deleteIndexes = [];
	values.do{ arg x, i;
		var dict = Dictionary.new;
		var set = Set.new, index;
		x.postln;
		x.do{|element| set = set.add(element)};
		dict.add('set' -> set);
		dict.add('id'-> i.asString);
		dictionaries = dictionaries.add(dict)
	};
	//dictionaries.postln;
	dictionaries.do{arg x, i;
		dictionaries.do{arg y, j;
			if(
				( ( x.at('set') & y.at('set') ) == x.at('set') ) &&
				(i!=j)
			){
				//x.at('set').postln;
				deleteIndexes = deleteIndexes.add(indexes[i])
			}
			}};
		deleteIndexes
});
//~content.value( [ [20,88], [16,20,28,88] ], [0,1] )
//~redundant_rules.value(~rules)



