
/**
 * This file was created by truffle-test-generator.
 * For every test, a new contract will be created in the
 * top beforeEach block. This line uses the arguments for
 * your contract's constructor with the same variable names.
 * Each public, non-constant (view) method has a describe
 * block generated for it.
 */
const LoanAndRefund = artifacts.require('LoanAndRefund')

contract('LoanAndRefund', (accounts) => {
  const maintainer = accounts[0]
  const user1 = accounts[1]
  const user2 = accounts[2]
  const stranger = accounts[3]

  let loanandrefund

  // Be sure to update these constructor values
  let timeally = 0

  beforeEach(async () => {
    loanandrefund = await LoanAndRefund.new(timeally, {from: maintainer})
  })

  describe('RefundList', () => {

  })

  describe('Loans', () => {

  })

  describe('LoanList', () => {

  })

  describe('Refunds', () => {

  })

  describe('ViewLoan', () => {

  })

  describe('ViewRefund', () => {

  })

  describe('AddLoan', () => {

  })

  describe('RemoveLoan', () => {

  })

  describe('AddRefund', () => {

  })

  describe('MonthlyRefundHandler', () => {

  })

  describe('MonthlyLoanHandler', () => {

  })
})
