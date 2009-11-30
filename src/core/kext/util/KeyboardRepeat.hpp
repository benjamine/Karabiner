#ifndef KEYBOARDREPEAT_HPP
#define KEYBOARDREPEAT_HPP

#include "base.hpp"
#include "keycode.hpp"
#include "Config.hpp"
#include "CallbackWrapper.hpp"
#include "TimerWrapper.hpp"

namespace org_pqrs_KeyRemap4MacBook {
  class KeyboardRepeat {
  public:
    KeyboardRepeat(void) {}

    static void initialize(IOWorkLoop& workloop);
    static void terminate(void);

    static void setTS(const AbsoluteTime& ts) { params_.ts = ts; }

    static void set(KeyEvent::KeyEvent eventType = KeyEvent::DOWN, unsigned int flags = 0, KeyCode::KeyCode key = KeyCode::NONE, KeyboardType::KeyboardType keyboardType = KeyboardType::MACBOOK,
                    int wait = config.get_repeat_initial_wait());

    static void set(const Params_KeyboardEventCallBack& p,
                    int wait = config.get_repeat_initial_wait()) {
      set(static_cast<KeyEvent::KeyEvent>(p.eventType), p.flags, static_cast<KeyCode::KeyCode>(p.key), static_cast<KeyboardType::KeyboardType>(p.keyboardType), wait);
    }

    static void cancel(void) {
      set();
    }

  private:
    static void fire(OSObject* owner, IOTimerEventSource* sender);

    static TimerWrapper timer_;
    static Params_KeyboardEventCallBack params_;
  };
}

#endif
