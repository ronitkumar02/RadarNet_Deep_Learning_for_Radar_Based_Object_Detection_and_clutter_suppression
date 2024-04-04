function helperPlotTrainingProgress(info)
% Plot training progress

figure
plot(10*log10(info.TrainingLoss))
hold on
plot(10*log10(info.ValidationLoss),'*')
hold off
grid on
legend('Training','Validation')
title('Training Progress')
xlabel('Iteration')
ylabel('Loss (dB)')

end