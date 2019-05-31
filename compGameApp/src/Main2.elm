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
  , record : List (Table.Row Msg)
  , period : Int
  }


init : Model
init =
  { n = "0"
  , q1 = ""
  , q2 = ""
  , q3 = ""
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
      { model | q1 = String.fromInt (Maybe.withDefault 0 (String.toInt newQ1))
              , n = String.fromInt (Maybe.withDefault 0 (String.toInt newQ1) + Maybe.withDefault 0 (String.toInt model.q2) + Maybe.withDefault 0 (String.toInt model.q3))
              }

    UpdateQ2 newQ2 ->
      { model | q2 = String.fromInt (Maybe.withDefault 0 (String.toInt newQ2))
              , n = String.fromInt (Maybe.withDefault 0 (String.toInt model.q1) + Maybe.withDefault 0 (String.toInt newQ2) + Maybe.withDefault 0 (String.toInt model.q3))
              }

    UpdateQ3 newQ3 ->
      { model | q3 = String.fromInt (Maybe.withDefault 0 (String.toInt newQ3))
              , n = String.fromInt (Maybe.withDefault 0 (String.toInt model.q1) + Maybe.withDefault 0 (String.toInt model.q2) + Maybe.withDefault 0 (String.toInt newQ3))
              -- , p1 = round ((0.3 * toFloat model.n) * (1.0 / toFloat model.q1) - 1.0)
              -- , p2 = round ((0.5 * toFloat model.n) - (toFloat model.q2))
              -- , p3 = round ((1/25) * toFloat model.n^2 - toFloat (Maybe.withDefault 0 (String.toInt newQ3))^2)
              }

    Increment ->
      { model | record = model.record ++ [ 
                  Table.tr []
                    [ Table.td [] [text (String.fromInt model.period)]
                    , Table.td [] [text (String.fromInt (round ((0.3 * toFloat (Maybe.withDefault 0 (String.toInt model.n)) * (1.0 / toFloat (Maybe.withDefault 0 (String.toInt model.q1))) - 1.0) ) ) ) ]
                    , Table.td [] [text (String.fromInt (round ((0.5 * toFloat (Maybe.withDefault 0 (String.toInt model.n))) - (toFloat (Maybe.withDefault 0 (String.toInt model.q2)))) ) )]
                    , Table.td [] [text (String.fromInt (round ((1/25) * toFloat (Maybe.withDefault 0 (String.toInt model.n))^2 - toFloat (Maybe.withDefault 0 (String.toInt model.q3))^2)))]
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
              , n = "0"
      } 

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
        Grid.col [ Col.md ] [
            div [] [Html.h4 [] [text "Number of Participants: "]
                    , div [] [ Html.h4 [] [text model.n ]]
            --         , div [classList [
            --     ("space", True)
            -- ]] [ br [] [] ]
            ] 
            , div [] [--div [] [img [src "apples.png", width 300] [] ]
                    --, 
                    text "Producers in Apple Market: "
                    , Input.number [ Input.id "apple", Input.attrs [placeholder "Students in Apple Market", value model.q1] , Input.onInput UpdateQ1 ] 
                    , div [] [ text ("Apple Profit: " ++ (String.fromInt (round ((0.3 * toFloat (Maybe.withDefault 0 (String.toInt model.n)) * (1.0 / toFloat (Maybe.withDefault 0 (String.toInt model.q1))) - 1.0) ) ) ) ) ]
            ]
            , div [] [--div [] [img [src "oranges.png", width 300] [] ]
                    --, 
                    text "Producers in Orange Market: "
                    , Input.number [ Input.id "orange", Input.attrs [placeholder "Students in Orange Market", value model.q2] , Input.onInput UpdateQ2 ]
                    , div [] [ text ("Orange Profit: " ++ (String.fromInt (round ((0.5 * toFloat (Maybe.withDefault 0 (String.toInt model.n))) - (toFloat (Maybe.withDefault 0 (String.toInt model.q2)))) ) ) ) ]
            ]
            , div [] [--div [] [img [src "bananas.png", width 300] [] ]
                    --, 
                    text "Producers in Banana Market: "
                    , Input.number [ Input.id "banana", Input.attrs [placeholder "Students in Banana Market", value model.q3], Input.onInput UpdateQ3 ]
                    , div [] [ text ("Banana Profit: " ++ (String.fromInt (round ((1/25) * toFloat (Maybe.withDefault 0 (String.toInt model.n))^2 - toFloat (Maybe.withDefault 0 (String.toInt model.q3))^2))) ) ]
            ]
            , div [classList [
                ("button", True)]] [ br [] []
                                     , Button.button [ Button.success, Button.onClick Increment, Button.attrs [ Spacing.ml1 ] ] [ text "Record Scores" ]
                                     , Button.button [ Button.danger, Button.onClick Clear, Button.attrs [Spacing.ml1 ] ] [ text "Clear Scores" ]
                                     , br [] []
                                     
                                    ]
        ]
    , Grid.col [ Col.md ] [ br [] []
                          , Table.table
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

    ]
    ]
        

    ]
  

-- TABLE SPECS

tRows : List (Table.Row msg)
tRows = 
  []
