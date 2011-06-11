start:
  desc: """
    You are standing on a path in the middle of a forrest.
    You see a house up ahead.
  """
  commands:
    house: "house"
    n: "house"
    
house:
  desc: """
    you are in the front room of a small house
  """
  commands:
    path: "start"

"Termite holes":
  desc: """
    You are thirty feet underground in a huge colony of termites!
  """
  dig: "deeper"
