extends Node

signal card_clicked(card)
signal card_right_clicked(card)
signal display_text(card)
signal close_textbox

# Timeline
signal card_dropped(card: Card)
signal card_dragged(card: Card)
signal validate_successful(batch: int)
