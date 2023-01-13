const realDescribe = describe
// eslint-disable-next-line no-global-assign
describe = (name, fn) => { realDescribe(name, () => { fn() }) }
