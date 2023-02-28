#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE games, teams;")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
if [[ $YEAR != 'year' ]]
# Import teams
  then
  team_id=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER';")
  if [[ -z $team_id ]]
    then
    echo $($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
    if [[ $INSERT_TEAM_RESULT == "INSERT 0 1" ]]
      then
        echo Inserted into teams, $WINNER
    fi
  fi
    team_id=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT';")
  if [[ -z $team_id ]]
    then
    echo $($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
    if [[ $INSERT_TEAM_RESULT == "INSERT 0 1" ]]
      then
        echo Inserted into teams, $OPPONENT
    fi
  fi
      # Next round of the data import - games table
  
fi
done
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
if [[ $YEAR != 'year' ]]
  then
  game_id=$($PSQL "SELECT game_id FROM games LEFT JOIN teams ON games.winner_id = teams.team_id WHERE year=$YEAR AND round='$ROUND' AND name='$WINNER';")
  if [[ -z $game_id ]]
  then
  echo $($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals)
  VALUES ($YEAR, '$ROUND', (SELECT team_id FROM teams WHERE name='$WINNER'), (SELECT team_id FROM teams WHERE name='$OPPONENT'), $WINNER_GOALS, $OPPONENT_GOALS);") 
  fi
fi
done
