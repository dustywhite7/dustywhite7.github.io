import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events.Extra exposing (onChange)
import Html.Events exposing (onInput, onClick)
import Round
import Html.Parser
import Table
import Bootstrap.Grid as Grid
import Bootstrap.Grid.Col as Col
import Bootstrap.Grid.Row as Row
import Bootstrap.Card as Card
import Bootstrap.Card.Block as Block
import Bootstrap.Button as Button
import Bootstrap.Form.Input as Input
import Bootstrap.CDN as CDN
import Bootstrap.Utilities.Spacing as Spacing
import Bootstrap.Table as Table

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
  , record : List (Table.Row Msg)
  , period : Int
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
  , record = tRows
  , period = 1
  }



-- UPDATE


type Msg
  = UpdateQ1 String | UpdateQ2 String | UpdateQ3 String | Increment | Clear 


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
      { model | record = model.record ++ [ 
          Table.tr []
            [ Table.td [] [text (String.fromInt model.period)]
            , Table.td [] [text model.p1]
            , Table.td [] [text model.p2]
            , Table.td [] [text model.p3]
            , Table.td [] [text model.q1]
            , Table.td [] [text model.q2]    
            , Table.td [] [text model.q3]
            ]
      ]
              , period = model.period + 1}
    Clear ->
      { model | record = tRows
              , period = 1
              , q1 = ""
              , q2 = ""
              , q3 = ""
              , n = ""
              , p1 = ""
              , p2 = ""
              , p3 = "" } 

-- VIEW


view : Model -> Html Msg
view model =
  Grid.container []
    [ CDN.stylesheet
    , Grid.row [ Row.centerMd ] [
        Grid.col [] [
            Html.h1 [] [text "Market Equilibrium Game"]
        ]
        ]
    , Grid.row [ Row.centerMd ] [
        Grid.col [ Col.sm ] [
            div [classList [
                ("students", True)
                , ("invalid", (Maybe.withDefault 0 (String.toFloat model.n)) > 0 )
            ]] [Html.h4 [] [text "Number of Participants: "]
                    , div [] [ Html.h4 [] [text (Round.round 0 ( (Maybe.withDefault 0 (String.toFloat model.n)))) ]]
            --         , div [classList [
            --     ("space", True)
            -- ]] [ br [] [] ]
            ] 
            , div [classList [
                ("industry", True)
                , ("invalid", (Maybe.withDefault 0 (String.toFloat model.q1)) > 0 )
            ]] [--div [] [img [src "apples.png", width 300] [] ]
                    --, 
                    text "Producers in Apple Market: "
                    , Input.text [ Input.attrs [placeholder "Students in Apple Market", value model.q1] , Input.onInput UpdateQ1 ] 
                    , div [] [ text ("Apple Profit: " ++ model.p1 )  ]
            ]
            , div [classList [
                ("industry", True)
                , ("invalid", (Maybe.withDefault 0 (String.toFloat model.q2)) > 0 )
            ]] [--div [] [img [src "oranges.png", width 300] [] ]
                    --, 
                    text "Producers in Orange Market: "
                    , Input.text [ Input.attrs [placeholder "Students in Orange Market", value model.q2] , Input.onInput UpdateQ2 ]
                    , div [] [ text ("Orange Profit: " ++ model.p2 ) ]
            ]
            , div [classList [
                ("industry", True)
                , ("invalid", (Maybe.withDefault 0 (String.toFloat model.q3)) > 0 )
            ]] [--div [] [img [src "bananas.png", width 300] [] ]
                    --, 
                    text "Producers in Banana Market: "
                    , Input.text [ Input.attrs [placeholder "Students in Banana Market", value model.q3], Input.onInput UpdateQ3 ]
                    , div [] [ text ("Banana Profit: " ++ model.p3 ) ]
            ]
            , div [classList [
                ("button", True)]] [ br [] []
                                     , Button.button [ Button.success, Button.onClick Increment, Button.attrs [ Spacing.ml1 ] ] [ text "Record Scores" ]
                                     , Button.button [ Button.danger, Button.onClick Clear, Button.attrs [Spacing.ml1 ] ] [ text "Clear Scores" ]]
        ]
    , Grid.col [ Col.sm ] [
        Table.table
            { options = [ Table.striped, Table.hover ]
            , thead =  Table.simpleThead
                [ Table.th [] [ text "Round Number" ]
                , Table.th [] [ text "Profit Apples" ]
                , Table.th [] [ text "Profit Oranges" ]
                , Table.th [] [ text "Profit Bananas" ]
                , Table.th [] [ text "Apple Firms" ]
                , Table.th [] [ text "Orange Firms" ]
                , Table.th [] [ text "Banana Firms" ]
                ]
            , tbody =
                Table.tbody []
                    model.record
            }
    --     div [classList [
    --   ("textTable", True)]] [ br [] []
    --   , Table.view config model.pTable model.record ]
    ]
    ]
        

    ]
  

-- config : Table.Config OneRound Msg
-- config =
--   Table.config
--     { columns = 
--       [ Table.stringColumn "Round" .roundNo
--       , Table.stringColumn "Profit Apples" .p1
--       , Table.stringColumn "Profit Oranges" .p2
--       , Table.stringColumn "Profit Bananas" .p3
--       , Table.stringColumn "# Apples" .q1
--       , Table.stringColumn "# Oranges" .q2
--       , Table.stringColumn "# Bananas" .q3

--       ]
--     , toId = .roundNo
--     , toMsg = SetTableState

--     }


-- TABLE SPECS

tRows : List (Table.Row msg)
tRows = 
  []
