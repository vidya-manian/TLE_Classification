

%Classify Validation Images

[YPred,probs] = classify(net,augimdsValidation);
accuracy = mean(YPred == imdsValidation.Labels);
validationError = mean(YPred ~= imdsValidation.Labels);

% YTrainPred = classify(net,XTrain);
% trainError = mean(YTrainPred ~= TTrain);
% 
% disp("Validation error: " + validationError*100 + "%")
% disp("Training error: " + trainError*100 + "%")


figure();
cm = confusionchart(imdsValidation.Labels,YPred);
cm.Title = "Confusion Matrix for Validation Data";
cm.ColumnSummary = "column-normalized";
cm.RowSummary = "row-normalized";
