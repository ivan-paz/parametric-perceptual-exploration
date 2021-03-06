//"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
//          this file contains functions for:
//          select unique rules
//          unify rule intervals
//""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

// Little function to find the non repeated rules
~unique_rules = {arg rules;
        var temporal = [];
        rules.do{arg permutation;
                permutation.do{arg rule;
                if(temporal.indexOfEqual(rule).isNil){
                temporal = temporal.add(rule)}}};
                temporal
};


//"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
//                        unification of rules
//
//"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

~unification_of_rules = {
arg rules, intervals_and_distances;
var indexes; var result = [];
var intAndIndex;
var temporalRules = rules.deepCopy;///////
indexes = (0 .. rules[0].size - 2);
indexes.collect{ arg colToExclude;
        //var temporalRules = rules;
        var section, subsets, selection;
        var temporal = [];
        section = (0.. indexes.size).removing(colToExclude);
        subsets = temporalRules.slice(nil,section);
        selection = temporalRules.slice(nil,colToExclude);
        subsets.do{ arg row, i;
                var values = [], indexes = [], newRule;
                values = values.add(selection[i]);indexes=indexes.add(i);
                subsets.do{ arg row1, j;
                if((row==row1) && (i!=j)){
                        if(row1.notNil){
                        values = values.add(selection[j]);
                        indexes = indexes.add(j)};
                }};
                if(values.size>1){'values and indexes : '.post; values.post; indexes.postln;
                        intAndIndex=~unify_intervals.value(values,indexes,colToExclude,intervals_and_distances).postln;
                        intAndIndex[0].do{|x|
                                        newRule = rules[i].deepCopy;
                                        newRule[colToExclude]=x;
                                        'newRule = '.post;newRule.postln;
                                        if(temporalRules.indexOfEqual(newRule).isNil){
                                        temporalRules = temporalRules.add(newRule);'regla añadida'.postln}{'INDEX : '.post;temporalRules.indexOfEqual(newRule).postln}
                                };
                                intAndIndex[1].do{|indexes|
                                indexes.do{|id| temporalRules[id]=nil}
                                }
                };
};
'temporal rules'.postln;
temporalRules.do{|x,i| [i,x].postln}
};
temporalRules.do{arg x;
        if(x.notNil){result = result.add(x)}};
result
};
//~unification_of_rules.value(~rules,~intervals_and_distances);
//-------------------------------------------------------------------
~find_threshold ={arg value, colToExclude, intervals_and_distances;
        var threshold;
        intervals_and_distances[colToExclude].do{ arg interval;
                if((value>interval[0][0])&&(value<=interval[0][1])){threshold=interval[1]}
        };
        threshold;
};
//~find_threshold.value( 48, 0, ~intervals_and_distances);

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
//             function than receives the values and
//          indexes and unify the intervals considering thresholds
//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
~unify_intervals = {|values,indexes,colToExclude,intervals_and_distances|
        var interval, extension;
        var threshold, currentInterval=[nil,nil];
        var flag = 0;
        var temp;
        var result = [];
        var tempIndex = [];
        var deleteIndexes = [];
        var compare;
        (values.size - 1).do{ |i| //'i : '.post; i.postln;
                if(flag==0){interval = ~limits.value(values[i])}{
                interval=currentInterval};
                extension = ~limits.value(values[i+1]);
                //threshold = ~find_threshold.value(interval[1],colToExclude,intervals_and_distances);
                //'comparando : '.post;e(interval,extension).postln;
                // Find the intermediate values to compare
                compare = ~compare.value(interval,extension);
                threshold = ~find_threshold.value(compare[0],colToExclude,intervals_and_distances);
                if( abs(compare[0]-compare[1])<= threshold ){
                        flag=1;
                        currentInterval[0]=min(interval[0],extension[0]);
                        currentInterval[1]=max(interval[1],extension[1]);
                        tempIndex = tempIndex.add(indexes[i]);///******
                        tempIndex = tempIndex.add(indexes[i+1]);///*****
                }{
                        flag = 0;
                        temp = currentInterval.deepCopy;
                        //'Temp : '.post; temp.postln;
                        result = result.add(temp);
                        //'result ==== '.post; result.postln;
                        deleteIndexes = deleteIndexes.add([tempIndex.first,tempIndex.last]);
                        tempIndex = [];
                }
        };
        if(flag==1){result = result.add(currentInterval);deleteIndexes = deleteIndexes.add(tempIndex)};
        [result,deleteIndexes]
};
//~unify_intervals.value([[48,783],[16,48]],[1,0],0,~intervals_and_distances)
//~unify_intervals.value([ [16,48], [48,783],[10,48],1880,2000,5000, 5020] , [0,1,2,3,4,5,6],0,~intervals_and_distances )
//-------------------------------------------------------------------
(~limits ={|value| var left, right;
        if(value.class!=Array){left=value;right=value}{
        left=value[0];right=value[1]};
        [left,right]});
//-------------------------------------------------------------------
(~compare = {|interval,extension|
        var one, two, three, four;
        var all = [], delete;
        interval.collect({|x| all = all.add(x)});
        extension.collect({|x| all = all.add(x)});
        one = all.minItem;
        delete = all.indexOfEqual(one);
        all.removeAt(delete);
        four = all.maxItem; delete = all.indexOfEqual(four);
        all.removeAt(delete);
        all
});
//~compare.value([1,2],[4,3])
