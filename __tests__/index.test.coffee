import axios from 'axios'
import MockAdapter from 'axios-mock-adapter'
import vrfAction from '../src'

mock = new MockAdapter(axios)
formData = {
  title: 'Test title',
  description: 'Test description'
}

messages = 'Произошла ошибка!'

getEffectWrapper = (formFields = {}) ->
  form = {
    $http: axios
    name: 'TestTodo#action'
    rfId: 234234
    $resource: formData
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
    resource = await wrapper.listeners.onLoad()

    expect(resource).toEqual(formData)
  )

  it('should save sources', () ->
    mock.onPost('test_todo/234234/action').reply((config) ->
      { title, description } = JSON.parse(config.data)
      return [200, { title, description }]
    )

    wrapper = getEffectWrapper()
    response = await wrapper.listeners.onSave(formData)

    expect(response).toEqual([true, formData])
  )

  it('should error when sources saving', () ->
    mock.onPost('test_todo/234234/action').reply(() -> [422, { messages }])

    wrapper = getEffectWrapper()
    response = await wrapper.listeners.onSave(formData)

    expect(response).toEqual([false, messages])
  )
)
