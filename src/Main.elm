module Main exposing (..)

import Json.Encode as Encode
import PortIn
import PortOut


main =
    Platform.worker
        { init = init
        , subscriptions = subscriptions
        , update = update
        }


type alias Model =
    Int


type Msg
    = NoOp
    | PortMsg PortIn.PortInMsg


init : () -> ( Model, Cmd Msg )
init _ =
    ( 1
    , Cmd.batch
        [ PortOut.send <| PortOut.Log (Encode.string "log message as string")
        , PortOut.send <| PortOut.Store (Encode.object [ ( "id", Encode.int 1 ) ])
        , PortOut.send <| PortOut.Get (Encode.int 3)
        ]
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        PortMsg inMsg ->
            let
                _ =
                    Debug.log "PortInMsg" inMsg
            in
            ( model, Cmd.none )

        _ ->
            ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.batch
        [ PortIn.toElm PortIn.toElmHandler |> Sub.map PortMsg ]
