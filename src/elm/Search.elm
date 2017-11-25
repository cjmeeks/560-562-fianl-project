module Search exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Types exposing (Msg(..), Model, Player, Team, initModel)
import Bootstrap.Form.Input as Input


view : Html Msg
view =
    div []
        [ text "Search View"
        , likeView "test"
        , numberView "numberTest"
        ]


likeView : String -> Html Msg
likeView name =
    div [ class "row" ]
        [ label [] [ text name ], div [ class "col-3" ] [ Input.text [ Input.attrs [ onInput (((,) name) >> LikeInput) ] ] ] ]


numberView : String -> Html Msg
numberView name =
    div [ class "row" ]
        [ div [ class "col-12" ] [ h3 [] [ text name ] ]
        , div [ class "col-12" ]
            [ div [ class "row" ]
                [ text "Exact"
                , div [ class "col-3" ] [ Input.number [ Input.attrs [ onInput (((,) name) >> ExactInput) ] ] ]
                , text "More Than"
                , div [ class "col-3" ] [ Input.number [ Input.attrs [ onInput (((,) name) >> MoreThanInput) ] ] ]
                , text "Less Than"
                , div [ class "col-3" ] [ Input.number [ Input.attrs [ onInput (((,) name) >> LessThanInput) ] ] ]
                ]
            ]
        ]
