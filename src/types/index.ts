export type THttpError = {
  messages:
    | { [key: string]: string }
    | string[]
    | string
}

type TContextListenerKey =
  | 'onLoad'
  | 'onSave'

export type TContextListeners = {
  [key in TContextListenerKey]?: (Promise) => void
}
