module UI.Flow where

import Effect.Console (log)
import Effect.Unsafe (unsafePerformEffect)
import Engineering.Helpers.Commons (runUI')
import Engineering.Types.App (Flow, liftLeft)
import Prelude (bind, pure)
import Product.Types (Operator, MobileNumber, Amount, BillPayFailure(..), BillPayStatus)
import UI.Types (AskAmountScreen(..), AskAmountScreenAction(..), AskMobileNumberScreen(..), AskMobileNumberScreenAction(..), ChooseOperatorScreen(..), ChooseOperatorScreenAction(..), SplashScreen(..), SplashScreenAction(..), StatusScreen(..), StatusScreenAction(..))


splashScreen :: Flow BillPayFailure SplashScreenAction
splashScreen = do
	action <- runUI' SplashScreen
	case action of
		SplashScreenRendered -> pure SplashScreenRendered

chooseOperator :: Array Operator -> Flow BillPayFailure Operator
chooseOperator operators = do
	action <- runUI' (ChooseOperatorScreen operators)
	case action of 
		OperatorSelected operator-> pure operator
		ChooseOperatorScreenAbort -> liftLeft UserAbort
	
askMobileNumber' :: String -> Flow BillPayFailure MobileNumber
askMobileNumber' errMsg = do
	action <- runUI' (AskMobileNumberScreen errMsg)
	case action of
		SubmitMobileNumber mobileNumber -> pure mobileNumber
		AskMobileNumberScreenNotEnoughNumbers -> do
			-- TODO: without splash screen, it doesn't update the state
			_ <- splashScreen
			askMobileNumber' "Not Enough Numbers"
		AskMobileNumberScreenAbort -> liftLeft UserAbort

askMobileNumber :: Flow BillPayFailure MobileNumber
askMobileNumber = askMobileNumber' ""

askAmount :: Flow BillPayFailure Amount
askAmount = do
	action <- runUI' AskAmountScreen
	case action of
		SubmitAmount amount -> pure amount
		AskAmountScreenAbort -> liftLeft UserAbort


billPayStatus :: MobileNumber -> Amount -> BillPayStatus -> Flow BillPayFailure StatusScreenAction
billPayStatus mobileNumber amount payStatus = do
	action <- runUI' (StatusScreen mobileNumber amount payStatus)
	case action of
		SuccessResult -> pure SuccessResult
		StatusScreenAbort -> liftLeft UserAbort

