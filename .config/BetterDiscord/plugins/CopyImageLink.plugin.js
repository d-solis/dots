/**
 * @name CopyImageLink
 * @description Adds (Copy Link) button next to (Open Original) under images
 * @version 1.0.3
 * @author Skamt
 * @website https://github.com/Skamt/BDAddons/tree/main/CopyImageLink
 * @source https://raw.githubusercontent.com/Skamt/BDAddons/main/CopyImageLink/CopyImageLink.plugin.js
 */
const config = {
	info: {
		name: "CopyImageLink",
		version: "1.0.3",
		description: "Adds (Copy Link) button next to (Open Original) under images",
		source: "https://raw.githubusercontent.com/Skamt/BDAddons/main/CopyImageLink/CopyImageLink.plugin.js",
		github: "https://github.com/Skamt/BDAddons/tree/main/CopyImageLink",
		authors: [{
			name: "Skamt"
		}]
	}
};
module.exports = (() => {
	const {
		UI,
		DOM,
		React,
		Patcher,
		Webpack: {
			getModule
		}
	} = new BdApi(config.info.name);
	// https://discord.com/channels/86004744966914048/196782758045941760/1062604534922367107
	function getModuleAndKey(filter) {
		let module;
		const target = BdApi.Webpack.getModule((entry, m) => filter(entry) ? (module = m) : false, { searchExports: true })
		return [module.exports, Object.keys(module.exports).find(k => module.exports[k] === target)];
	}
	// Modules
	const [ImageModalModule, ImageModalKey] = getModuleAndKey(m => {
		if (!m?.toString || typeof(m?.toString) !== "function") return;
		const strs = ["original", "maxHeight", "maxWidth", "noreferrer noopener"];
		const funcStr = m?.toString();
		for (const s of strs)
			if (!funcStr.includes(s)) return false;
		return true;
	});
	// Helper functions
	const Utils = {
		showToast: (content, type) => UI.showToast(`[${config.info.name}] ${content}`, { type }),
		copy: (data) => {
			DiscordNative.clipboard.copy(data);
			Utils.showToast("Link Copied!", "success");
		},
		/* Stolen from Zlib until it gets added to BdApi */
		getNestedProp: (obj, path) => path.split(".").reduce(function(ob, prop) {
			return ob && ob[prop];
		}, obj)
	};
	// components
	const copyButton = ({ href }) => {
		return (
			React.createElement(React.Fragment, null,
				React.createElement("span", { className: "copyBtnSpan" }, "|"),
				React.createElement("a", {
					className: "anchorUnderlineOnHover-2qPutX downloadLink-3cavAH copyBtn",
					onClick: (_) => Utils.copy(href)
				}, "Copy link")));
	};
	// styles
	const css = `.copyBtn {
	left: 115px;
	white-space: nowrap;
}

.copyBtnSpan {
	left: 105px;
	position: absolute;
	top: 100%;
	font-weight: 500;
	color: hsl(0, calc(var(--saturation-factor, 1) * 0%), 100%) !important;
	line-height: 30px;
	opacity: 0.5;
}`;
	return class CopyImageLink {
		start() {
			try {
				DOM.addStyle(css);
				Patcher.after(ImageModalModule, ImageModalKey, (_, __, returnValue) => {
					const children = Utils.getNestedProp(returnValue, "props.children");
					const { href } = Utils.getNestedProp(returnValue, "props.children.2.props");
					children.push(React.createElement(copyButton, { href }));
				});
			} catch (e) {
				console.error(e);
			}
		}
		stop() {
			DOM.removeStyle();
			Patcher.unpatchAll();
		}
	};
})();
