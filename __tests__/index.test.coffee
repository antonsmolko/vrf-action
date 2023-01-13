import axios from 'axios'
import MockAdapter from 'axios-mock-adapter'
import vrfAction from '../src'

mock = new MockAdapter(axios)
formData = {
  title: 'Test title',
  description: 'Test description'
}
mock.onPost('/todos.json').reply((config) ->
  { title, description } = JSON.parse(config.data).todo

  return [
    200,
    {
      title,
      description
    }
  ]
)

getEffectWrapper = (formFields = {}) ->
  form = {
    $http: axios
    name: 'TestTodo#action'
    formFields...
  }
  listeners = {}
  listenerMap = [
    'onLoad'
    'onSave'
  ].reduce(
    (subscribers, name) =>
      subscribers[name] = (listener) -> listeners[name] = listener
      subscribers
    {}
  )

  context = {
    listenerMap...
    form
  }

  return {
    instance: vrfAction().effect(context),
    listeners
  }

describe('VrfAction', () ->
  it('should loads data', () ->
    wrapper = getEffectWrapper()
    resource = await wrapper.listeners.onLoad(1)

    expect(resource).toEqual(formData)
  )
)
