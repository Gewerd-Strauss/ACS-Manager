ccc
Legacy=readmatrix("D:\Dokumente neu\000 AAA Dokumente\000 AAA HSRW\General\AHK scripts\Projects\AHK-Code-Snippets\LegacyBenchmark.txt");
SerDes=readmatrix("D:\Dokumente neu\000 AAA Dokumente\000 AAA HSRW\General\AHK scripts\Projects\AHK-Code-Snippets\SerDesBenchmark.txt");
LegacyLength=1:1:size(Legacy,1);
SerDesLength=1:1:size(SerDes,1);
LegacyNorm=Legacy./SerDes;

f1=fit(LegacyLength',Legacy,"poly1");
f2=fit(SerDesLength',SerDes,"poly1");
f3=fit(LegacyLength',LegacyNorm,"poly1");
hold on
plot(LegacyLength,Legacy,"ro")
plot(SerDesLength,SerDes,"bx")

plot(f1,"r")
plot(f2,"b")

legend('Data Points Legacy','Data Points SerDes','Regression Legacy','Regression SerDes','location', 'best')
str=append("Comparison of using SerDes on a json-like string vs the currently employed preparation method, # of Datapoints: ",  num2str(size(SerDesLength,2)), " vs ", num2str(size(SerDesLength,2)))
title(str)
xlabel('number of repeats')
ylabel('time in MS')
hold off
figure
hold on
plot(LegacyLength,LegacyNorm,"k*")
plot(f3,"k")
legend('Data Points Legacy normalised to SerDes','Regression Normalised legacy','location', 'best')
str=append("Speed of legacy method, normalised to SerDes' speed, # of Datapoints: ",  num2str(size(SerDesLength,2)), " vs ", num2str(size(SerDesLength,2)))
title(str)
xlabel('number of repeats')
ylabel('T_{Legacy}/T_{SerDes}')
str=append("Finished comparing ",  num2str(size(LegacyLength,2)),  " Legacy Datapoints vs ", num2str(size(SerDesLength,2)), " SerDes Datapoints")
disp(str)
LPcelldispForFits(f1)
LPcelldispForFits(f2)
disp(append("Ratio:",num2str(f1.p2/f2.p2)))

FracAd=(f1.p2/f2.p2) - 1; 
disp(append("Speed Advantage of SerDes: ",     num2str(FracAd)))