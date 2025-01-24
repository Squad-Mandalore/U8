extends Control

var counter: int = 1

func increment():
    counter += 1
    %RoundDescriptorLabel.text = "Runde " + str(counter)
