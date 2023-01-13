import { decamelize } from 'humps'

import urlJoin from 'url-join'

import { Effect } from 'vrf'
import { THttpError } from './types'

export default () : Effect => ({
  name: 'rest',
  api: true,
  effect({
    form,
    onLoad,
    onSave
  }) {
    const { name, resource, $http, rfId } = form
    const [basePath, actionPath] = name.split('#').map(decamelize)

    const url = rfId ? urlJoin(basePath, rfId, actionPath) : urlJoin(basePath, actionPath)

    onLoad(() => Promise.resolve(resource))

    onSave((data) => $http.post(url, data)
      .then((response): [boolean, unknown] => [true, response])
      .catch((error): [boolean, THttpError] => [false, error.response.data.messages]))
  }
})
