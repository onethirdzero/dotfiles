// This is an OpenCode v2 server plugin for
// https://github.com/accessd/tmux-agent-indicator,
// adapted from the upstream v1 version, since there isn't a v2 yet.
//
// Reports OpenCode session state to tmux-agent-indicator.
// Runs in the TUI process so it inherits this pane's TMUX_PANE.
import { execFile } from "node:child_process";

const dir =
  process.env.TMUX_AGENT_INDICATOR_DIR ||
  `${process.env.HOME}/.tmux/plugins/tmux-agent-indicator`;
const script = `${dir}/scripts/agent-state.sh`;

export default {
  id: "tmux-agent-indicator",
  setup(context) {
    if (!process.env.TMUX_PANE) return;

    let lastState = "off";
    const run = (state) =>
      new Promise((resolve) =>
        execFile("bash", [script, "--agent", "opencode", "--state", state], () => resolve()),
      );
    const setState = async (state) => {
      if (state === lastState) return;
      lastState = state;
      if (state === "running") await run("off");
      await run(state);
    };

    // The TUI receives events for every session on the server, so only
    // react to the session tree shown in this pane.
    const shownSessionID = () => {
      const route = context.ui.router.current();
      return route?.sessionID ?? route?.params?.sessionID;
    };
    const isShown = (sessionID) => {
      const shown = shownSessionID();
      if (!shown || !sessionID) return false;
      return context.data.session.root(sessionID) === context.data.session.root(shown);
    };
    const on = (type, state, sessionOf = (event) => event.data.sessionID) =>
      context.data.on(type, (event) => {
        if (isShown(sessionOf(event))) void setState(state);
      });

    const stops = [
      on("session.execution.started", "running"),
      on("permission.asked", "needs-input"),
      on("permission.replied", "running"),
      on("form.created", "needs-input", (event) => event.data.form.sessionID),
      on("form.replied", "running"),
      on("form.cancelled", "running"),
      on("session.execution.succeeded", "done"),
      on("session.execution.failed", "done"),
      on("session.execution.interrupted", "done"),
    ];
    return () => {
      stops.forEach((stop) => stop());
      void run("off");
    };
  },
};
