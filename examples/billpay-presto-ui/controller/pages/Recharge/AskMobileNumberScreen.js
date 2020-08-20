const View = require("presto-ui").baseView;

class AskMobileNumberScreen extends View {

	constructor(props, children, state) {
		super(props, children, state);
		this.errorMessage = state.contents;
		this.shouldCacheScreen = false;
	
		this.mobileNumber = "";

		this.style_Placeholder = {
			inputType : "numeric",
			onChange : this.onEnteringMobileNumber.bind(this)
		}

		this.style_ButtonText = {
			width : "match_parent"
		}


		this.style_Button = {
			onClick : this.onRechargeClick.bind(this)
		}

		this.style_Icon = {
			onClick : this.onBackPressed.bind(this)
		}
	}

	onEnteringMobileNumber = (data) => {
		this.mobileNumber = data;
	}


	onRechargeClick = () => {
		if(this.mobileNumber.length == 10){
			window.__runDuiCallback(JSON.stringify({tag:"SubmitMobileNumber",contents:this.mobileNumber}));
		} else {
			window.__runDuiCallback(JSON.stringify({tag:"AskMobileNumberScreenNotEnoughNumbers"}));
		}
	}

	onBackPressed = () => {
		window.__runDuiCallback(JSON.stringify({tag:"AskMobileNumberScreenAbort"}));
	}

	handleStateChange = (state) => {
		this.errorMessage = state.contents;
		// TODO: how to trigger a rerender?
	}
}

module.exports = AskMobileNumberScreen;
