import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events.Extra exposing (onChange)
import Html.Events exposing (onInput, onClick)
import Round
import Html.Parser
import Table
import Bootstrap.Navbar as Navbar
import Bootstrap.Grid as Grid
import Bootstrap.Grid.Col as Col
import Bootstrap.Card as Card
import Bootstrap.Card.Block as Block
import Bootstrap.Button as Button
import Bootstrap.ListGroup as Listgroup
import Bootstrap.Modal as Modal

-- MAIN


main =
  Browser.sandbox { init = init, update = update, view = view }



-- MODEL


type alias Model =
  { n : String
  , q1 : String
  , q2 : String
  , q3 : String
  , p1 : String
  , p2 : String
  , p3 : String
  , record : List OneRound
  , period : Int
  , pTable : Table.State
  }


init : Model
init =
  { n = ""
  , q1 = ""
  , q2 = ""
  , q3 = ""
  , p1 = ""
  , p2 = ""
  , p3 = ""
  , record = allRounds
  , period = 1
  , pTable = Table.initialSort "Round"
  }



-- UPDATE


type Msg
  = UpdateQ1 String | UpdateQ2 String | UpdateQ3 String | Increment | Clear | SetTableState Table.State


update : Msg -> Model -> Model
update msg model =
  case msg of
    UpdateQ1 newQ1 ->
      { model | q1 = newQ1
              , n = Round.round 0 (Maybe.withDefault 0 (String.toFloat newQ1) + Maybe.withDefault 0 (String.toFloat model.q2) + Maybe.withDefault 0 (String.toFloat model.q3))
              , p1 = (Round.round 0 ( (Maybe.withDefault 0 (String.toFloat model.n)) * sqrt (5/(Maybe.withDefault 0 (String.toFloat model.q1))) - (Maybe.withDefault 0 (String.toFloat model.n))/2) ) 
              , p2 = (Round.round 0 ( (Maybe.withDefault 0 (String.toFloat model.n))/20 * cos ((pi/(Maybe.withDefault 0 (String.toFloat model.n))) * (Maybe.withDefault 0 (String.toFloat model.q2)) ) + (Maybe.withDefault 0 (String.toFloat model.n))/20 ) ) 
              , p3 = (Round.round 0 ( (3/4) * (Maybe.withDefault 0 (String.toFloat model.n)) - (Maybe.withDefault 0 (String.toFloat model.q3))) ) }
    UpdateQ2 newQ2 ->
      { model | q2 = newQ2
              , n = Round.round 0 (Maybe.withDefault 0 (String.toFloat model.q1) + Maybe.withDefault 0 (String.toFloat newQ2) + Maybe.withDefault 0 (String.toFloat model.q3))
              , p1 = (Round.round 0 ( (Maybe.withDefault 0 (String.toFloat model.n)) * sqrt (5/(Maybe.withDefault 0 (String.toFloat model.q1))) - (Maybe.withDefault 0 (String.toFloat model.n))/2) ) 
              , p2 = (Round.round 0 ( (Maybe.withDefault 0 (String.toFloat model.n))/20 * cos ((pi/(Maybe.withDefault 0 (String.toFloat model.n))) * (Maybe.withDefault 0 (String.toFloat model.q2)) ) + (Maybe.withDefault 0 (String.toFloat model.n))/20 ) ) 
              , p3 = (Round.round 0 ( (3/4) * (Maybe.withDefault 0 (String.toFloat model.n)) - (Maybe.withDefault 0 (String.toFloat model.q3))) ) }
    UpdateQ3 newQ3 ->
      { model | q3 = newQ3
              , n = Round.round 0 (Maybe.withDefault 0 (String.toFloat model.q1) + Maybe.withDefault 0 (String.toFloat model.q2) + Maybe.withDefault 0 (String.toFloat newQ3))
              , p1 = (Round.round 0 ( (Maybe.withDefault 0 (String.toFloat model.n)) * sqrt (5/(Maybe.withDefault 0 (String.toFloat model.q1))) - (Maybe.withDefault 0 (String.toFloat model.n))/2) ) 
              , p2 = (Round.round 0 ( (Maybe.withDefault 0 (String.toFloat model.n))/20 * cos ((pi/(Maybe.withDefault 0 (String.toFloat model.n))) * (Maybe.withDefault 0 (String.toFloat model.q2)) ) + (Maybe.withDefault 0 (String.toFloat model.n))/20 ) ) 
              , p3 = (Round.round 0 ( (3/4) * (Maybe.withDefault 0 (String.toFloat model.n)) - (Maybe.withDefault 0 (String.toFloat model.q3))) ) }
    Increment ->
      { model | record = model.record ++ [OneRound (String.fromInt model.period) model.p1 model.p2 model.p3 model.q1 model.q2 model.q3 model.n]
              , period = model.period + 1}
    Clear ->
      { model | record = allRounds
              , period = 1
              , q1 = ""
              , q2 = ""
              , q3 = ""
              , n = ""
              , p1 = ""
              , p2 = ""
              , p3 = ""
              , pTable = Table.initialSort "Round"}
    SetTableState newState ->
      { model | pTable = newState }  

-- VIEW


view : Model -> Html Msg
view model =
  div []
    [
    div [classList [
        ("title", True)
    ]] [text "Market Equilibrium Game"]
    , div [classList [
        ("students", True)
        , ("invalid", (Maybe.withDefault 0 (String.toFloat model.n)) > 0 )
    ]] [text "Number of Participants: "
            , div [] [ text (Round.round 0 ( (Maybe.withDefault 0 (String.toFloat model.n)))) ]
            , div [classList [
        ("space", True)
    ]] [ br [] [] ]
    ] 
    , div [classList [
        ("industry", True)
        , ("invalid", (Maybe.withDefault 0 (String.toFloat model.q1)) > 0 )
    ]] [--div [] [img [src "apples.png", width 300] [] ]
            --, 
            text "Producers in Apple Market: "
            , input [ placeholder "Students in Apple Market", value model.q1, onInput UpdateQ1 ] []
            , div [] [ text ("Apple Profit: " ++ model.p1 )  ]
    ]
    , div [classList [
        ("industry", True)
        , ("invalid", (Maybe.withDefault 0 (String.toFloat model.q2)) > 0 )
    ]] [--div [] [img [src "oranges.png", width 300] [] ]
            --, 
            text "Producers in Orange Market: "
            , input [ placeholder "Students in Orange Market", value model.q2, onInput UpdateQ2 ] []
            , div [] [ text ("Orange Profit: " ++ model.p2 ) ]
    ]
    , div [classList [
        ("industry", True)
        , ("invalid", (Maybe.withDefault 0 (String.toFloat model.q3)) > 0 )
    ]] [--div [] [img [src "bananas.png", width 300] [] ]
            --, 
            text "Producers in Banana Market: "
            , input [ placeholder "Students in Banana Market", value model.q3, onInput UpdateQ3 ] []
            , div [] [ text ("Banana Profit: " ++ model.p3 ) ]
    ]
    , div [classList [
        ("button", True)]] [button [ onClick Increment ] [ text "Record Scores" ]]
      , div [classList [
        ("button", True)]] [button [ onClick Clear ] [ text "Clear Scores" ]]
    , div [classList [
      ("textTable", True)]] [ br [] []
      , Table.view config model.pTable model.record ]
    ]

config : Table.Config OneRound Msg
config =
  Table.config
    { columns = 
      [ Table.stringColumn "Round" .roundNo
      , Table.stringColumn "Profit Apples" .p1
      , Table.stringColumn "Profit Oranges" .p2
      , Table.stringColumn "Profit Bananas" .p3
      , Table.stringColumn "# Apples" .q1
      , Table.stringColumn "# Oranges" .q2
      , Table.stringColumn "# Bananas" .q3

      ]
    , toId = .roundNo
    , toMsg = SetTableState

    }


-- TABLE SPECS

type alias OneRound = 
  { roundNo : String
  , p1 : String
  , p2 : String
  , p3 : String
  , q1 : String
  , q2 : String
  , q3 : String
  , n : String
  }

allRounds : List OneRound
allRounds = 
  []