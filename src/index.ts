import { decamelize } from 'humps'
import compact from 'lodash/compact'

import urlJoin from 'url-join'

import { Effect } from 'vrf'

export default () : Effect => ({
  name: 'action',
  api: true,
  effect({
    form,
    onLoad,
    onSave
  }) {
    const { name, $resource, $http, rfId } = form
    const [basePath, actionPath] = name.split('#').map(decamelize)

    const url = urlJoin(...compact([basePath, rfId, actionPath]).map(String))

    onLoad(() => Promise.resolve($resource))

    onSave((data) => $http.post(url, data)
      .then((response) => [true, response.data])
      .catch((error) => [false, error.response.data.messages]))
  }
})
