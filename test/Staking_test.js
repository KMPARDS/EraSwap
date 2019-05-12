
/**
 * This file was created by truffle-test-generator.
 * For every test, a new contract will be created in the
 * top beforeEach block. This line uses the arguments for
 * your contract's constructor with the same variable names.
 * Each public, non-constant (view) method has a describe
 * block generated for it.
 */
const Staking = artifacts.require('Staking')

contract('Staking', (accounts) => {
  const maintainer = accounts[0]
  const user1 = accounts[1]
  const user2 = accounts[2]
  const stranger = accounts[3]

  let staking

  // Be sure to update these constructor values
  let timeally = 0

  beforeEach(async () => {
    staking = await Staking.new(timeally, {from: maintainer})
  })

  describe('Stakes', () => {

  })

  describe('Plans', () => {

  })

  describe('Status', () => {

  })

  describe('ViewStake', () => {

  })

  describe('ViewStakedAmount', () => {

  })

  describe('AddStake', () => {

  })

  describe('BatchAddStake', () => {

  })

  describe('Pause', () => {

  })

  describe('Resume', () => {

  })

  describe('MonthlyNRTHandler', () => {

  })

  describe('MonthlyPlanHandler', () => {

  })
})
