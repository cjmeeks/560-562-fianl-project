module Search exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Types exposing (Msg(..), Model, Player, Team, SearchType(..), initModel, listOfQueryParams)
import Bootstrap.Form.Input as Input
import Bootstrap.Button as Button


view : List ( String, List ( String, SearchType ) ) -> Html Msg
view searches =
    div []
        [ formView searches
        , Button.linkButton [ Button.primary ] [ text "Search" ]
        ]


likeView : String -> Html Msg
likeView name =
    div [ class "row" ]
        [ label [ class "col-2" ] [ text name ], div [ class "col-3" ] [ Input.text [ Input.attrs [ onInput (((,) name) >> LikeInput) ] ] ] ]


numberView : String -> Html Msg
numberView name =
    div [ class "row" ]
        [ div [ class "col-12" ] [ label [] [ text name ] ]
        , div [ class "col-12" ]
            [ div [ class "row" ]
                [ div [ class "col-1" ] [ text "Exact" ]
                , div [ class "col-2" ] [ Input.number [ Input.attrs [ onInput (((,) name) >> ExactInput) ] ] ]
                , div [ class "col-1" ] [ text "More Than" ]
                , div [ class "col-2" ] [ Input.number [ Input.attrs [ onInput (((,) name) >> MoreThanInput) ] ] ]
                , div [ class "col-1" ] [ text "Less Than" ]
                , div [ class "col-2" ] [ Input.number [ Input.attrs [ onInput (((,) name) >> LessThanInput) ] ] ]
                ]
            ]
        ]


formView : List ( String, List ( String, SearchType ) ) -> Html Msg
formView params =
    div [] <| List.map displaySection params


displaySection : ( String, List ( String, SearchType ) ) -> Html Msg
displaySection ( name, list ) =
    div [ class "row" ]
        [ h3 [] [ text name ]
        , div [ class "col-12" ] <| List.map displayBasedOnType list
        ]


displayBasedOnType : ( String, SearchType ) -> Html Msg
displayBasedOnType ( key, t ) =
    case t of
        Like ->
            likeView key

        Number ->
            numberView key
