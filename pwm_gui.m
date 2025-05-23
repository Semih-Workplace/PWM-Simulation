% GUI characteristic
function pwm_gui()
    
    % GUI dimensions
    fig = uifigure('Name', 'PWM Motor Control Simulation', 'Position', [100, 100, 1000, 500]);

    % Plot dimensions and names
    ax = uiaxes(fig, 'Position', [350, 60, 600, 400]);
    title(ax, 'PWM Signal');
    xlabel(ax, 'Time (s)');
    ylabel(ax, 'Voltage');

    %Information part
    voltLabel = uilabel(fig, 'Position', [40, 200, 300, 22], 'Text', 'Average Voltage:');

    SpeedLabel = uilabel(fig, 'Position', [40, 150, 300, 22], 'Text', 'Motor Speed:');

    % Changeable factors
    uilabel(fig, 'Position', [40, 400, 120, 22], 'Text', 'Frequency (Hz):');
    freqField = uieditfield(fig, 'numeric', 'Position', [170, 400, 120, 22], 'Value', 1000);

    uilabel(fig, 'Position', [40, 350, 120, 22], 'Text', 'Duty Cycle (%):');
    dutyField = uieditfield(fig, 'numeric', 'Position', [170, 350, 120, 22], 'Value', 50);

    uilabel(fig, 'Position', [40, 300, 120, 22], 'Text', 'Duration (s):');
    durationField = uieditfield(fig, 'numeric', 'Position', [170, 300, 120, 22], 'Value', 0.01);

    %Simulation Button
    uibutton(fig, 'Text', 'Generate PWM Signal', ...
        'Position', [150, 240, 160, 35], ...
        'ButtonPushedFcn', @(btn,event) plotPWM(freqField.Value, dutyField.Value, durationField.Value, ax, voltLabel,SpeedLabel));
end


% PWM Signal drawing

function plotPWM(freq, duty, duration, ax, voltLabel,SpeedLabel)
    %Simulation sample rate
    Fs = 10^8;  

    % Motor parameters
    Max_Voltage = 12;
    Max_Speed = 1200;

    % Plot command
    [t, pwm] = generate_pwm(freq, duty, duration, Fs,Max_Voltage);
    plot(ax, t, pwm);


    % Parameter calculation
    Motor_speed = mean(pwm) /Max_Voltage* Max_Speed;  
    avg_voltage = mean(pwm)  ;  

    voltLabel.Text = sprintf('Average Voltage: %.2f V', avg_voltage);
    SpeedLabel.Text = sprintf('Motor Speed: %.2f RPM', Motor_speed);
end


%PWM Signal generate

function [t, pwm_signal] = generate_pwm(frequency, duty_cycle, duration, sampling_rate,Max_Voltage)

    % Time vector
    t = 0:1/sampling_rate:duration;

    % Signal creation
    pwm_signal = zeros(size(t));

    %Period and high time determine
    T = 1 / frequency;
    high_time = T * (duty_cycle / 100);

    %Signal to PWM Signal 
    for i = 1:length(t)
        time_in_cycle = mod(t(i), T);
        pwm_signal(i) = (time_in_cycle < high_time) * Max_Voltage;
    end
end
