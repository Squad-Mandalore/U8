extends VBoxContainer

func update_resistance_info(stats: StatsSpecifier):
    update_bleed_resistance(stats.bleed_resistance, 100)
    update_poison_resistance(stats.poison_resistance, 100)
    update_drug_resistance(stats.drug_resistance, 100)

func get_ck3_progress_bar() -> TextureProgressBar:
    %Ck3ProgressBar.value = 0
    return %Ck3ProgressBar

func update_bleed_resistance(new_bleed_resistance: int, max_bleed_resistance: int) -> void:
    new_bleed_resistance = min(new_bleed_resistance, max_bleed_resistance)
    %BleedResistanceBar.set_max_value(max_bleed_resistance)
    %BleedResistanceBar.set_stat_name("Blutungsresistenz")
    %BleedResistanceBar.set_stat_number("%d/%d" % [new_bleed_resistance, max_bleed_resistance])
    %BleedResistanceBar.set_cur_value(new_bleed_resistance)

func update_poison_resistance(new_poison_resistance: int, max_poison_resistance: int) -> void:
    new_poison_resistance = min(new_poison_resistance, max_poison_resistance)
    %PoisonResistanceBar.set_max_value(max_poison_resistance)
    %PoisonResistanceBar.set_stat_name("Giftresistenz")
    %PoisonResistanceBar.set_stat_number("%d/%d" % [new_poison_resistance, max_poison_resistance])
    %PoisonResistanceBar.set_cur_value(new_poison_resistance)

func update_drug_resistance(new_drug_resistance: int, max_drug_resistance: int) -> void:
    new_drug_resistance = min(new_drug_resistance, max_drug_resistance)
    %DrugResistanceBar.set_max_value(max_drug_resistance)
    %DrugResistanceBar.set_stat_name("Drogenresistenz")
    %DrugResistanceBar.set_stat_number("%d/%d" % [new_drug_resistance, max_drug_resistance])
    %DrugResistanceBar.set_cur_value(new_drug_resistance)
